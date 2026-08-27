<script setup lang="ts">
import { computed, reactive, ref } from "vue";
import type { FilePIIs } from "../../composables/useScan";
import List from "../list/List.vue";
import StatTile from "../stat-tile/StatTile.vue";
import Button from "../button/Button.vue";
import Checkbox from "../checkbox/Checkbox.vue";
import SearchInput from "../search-input/SearchInput.vue";
import SortSelect, { type SortOption } from "../sort-select/SortSelect.vue";
import BatchActionBar from "../batch-action-bar/BatchActionBar.vue";
import FindingsTable from "../findings-table/FindingsTable.vue";

const props = defineProps<{ results: FilePIIs[] }>();
const emit = defineEmits<{ (e: "rescan"): void }>();

// Local-only simulation of destructive actions: no backend command exists for
// these yet, so redact/quarantine just mutate this screen's view of the data.
const quarantined = reactive(new Set<string>());
const redacted = reactive(new Set<string>());

function displayFile(file: FilePIIs): FilePIIs {
  if (!redacted.has(file.filename)) return file;
  return { ...file, email_accounts: [], phone_numbers: [], other_piis: [] };
}

function hasFindings(file: FilePIIs) {
  return (
    file.email_accounts.length > 0 ||
    file.phone_numbers.length > 0 ||
    file.other_piis.length > 0
  );
}

const visibleResults = computed(() =>
  props.results.filter((f) => !quarantined.has(f.filename)).map(displayFile),
);

const totalEmails = computed(() =>
  visibleResults.value.reduce((sum, f) => sum + f.email_accounts.length, 0),
);
const totalPhones = computed(() =>
  visibleResults.value.reduce((sum, f) => sum + f.phone_numbers.length, 0),
);
const totalOther = computed(() =>
  visibleResults.value.filter((f) => f.other_piis.length > 0).length,
);
const filesWithFindings = computed(() => visibleResults.value.filter(hasFindings));
const filesWithNoFindings = computed(() => visibleResults.value.filter((f) => !hasFindings(f)));
const filesWithEmail = computed(() => visibleResults.value.filter((f) => f.email_accounts.length > 0));
const filesWithPhone = computed(() => visibleResults.value.filter((f) => f.phone_numbers.length > 0));

// --- Filters ---
type StatusFilter = "all" | "has-findings" | "no-findings";
const statusFilter = ref<StatusFilter>("all");
const categoryFilter = reactive({ email: false, phone: false, other: false });
const search = ref("");
const sort = ref<SortOption>("most");

function toggleCategory(key: keyof typeof categoryFilter) {
  categoryFilter[key] = !categoryFilter[key];
}

function matchesStatus(file: FilePIIs) {
  if (statusFilter.value === "has-findings") return hasFindings(file);
  if (statusFilter.value === "no-findings") return !hasFindings(file);
  return true;
}

function matchesCategory(file: FilePIIs) {
  if (!categoryFilter.email && !categoryFilter.phone && !categoryFilter.other) return true;
  return (
    (categoryFilter.email && file.email_accounts.length > 0) ||
    (categoryFilter.phone && file.phone_numbers.length > 0) ||
    (categoryFilter.other && file.other_piis.length > 0)
  );
}

function findingCount(file: FilePIIs) {
  return file.email_accounts.length + file.phone_numbers.length + file.other_piis.length;
}

const sortOptions: { value: SortOption; label: string }[] = [
  { value: "most", label: "Most findings" },
  { value: "fewest", label: "Fewest findings" },
  { value: "az", label: "A-Z" },
  { value: "za", label: "Z-A" },
];

const filteredResults = computed(() => {
  const term = search.value.trim().toLowerCase();
  const filtered = visibleResults.value
    .filter(matchesStatus)
    .filter(matchesCategory)
    .filter((f) => !term || f.filename.toLowerCase().includes(term));

  return [...filtered].sort((a, b) => {
    switch (sort.value) {
      case "fewest":
        return findingCount(a) - findingCount(b);
      case "az":
        return a.filename.localeCompare(b.filename);
      case "za":
        return b.filename.localeCompare(a.filename);
      default:
        return findingCount(b) - findingCount(a);
    }
  });
});

// --- Selection ---
const selected = reactive(new Set<string>());

function toggleSelected(filename: string, value: boolean) {
  if (value) selected.add(filename);
  else selected.delete(filename);
}

function toggleAllSelected(value: boolean) {
  if (value) filteredResults.value.forEach((f) => selected.add(f.filename));
  else filteredResults.value.forEach((f) => selected.delete(f.filename));
}

function clearSelection() {
  selected.clear();
}

function confirmAnd(message: string, action: () => void) {
  if (window.confirm(message)) action();
}

function redactSelected() {
  confirmAnd(`Redact findings in ${selected.size} file(s)? This cannot be undone.`, () => {
    selected.forEach((filename) => redacted.add(filename));
    clearSelection();
  });
}

function quarantineSelected() {
  confirmAnd(`Quarantine ${selected.size} file(s)? They will be removed from this report.`, () => {
    selected.forEach((filename) => quarantined.add(filename));
    clearSelection();
  });
}

function exportSelected() {
  const target = selected.size > 0 ? visibleResults.value.filter((f) => selected.has(f.filename)) : visibleResults.value;
  const blob = new Blob([JSON.stringify(target, null, 2)], { type: "application/json" });
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.href = url;
  link.download = "scan-report.json";
  link.click();
  URL.revokeObjectURL(url);
}
</script>

<template>
  <section class="w-full text-left">
    <div class="flex flex-wrap items-start justify-between gap-6 px-8 pt-8 pb-6">
      <div>
        <h2 class="text-[28px] leading-[36px] font-semibold text-[#161616]">Scan Report</h2>
        <p class="mt-1 text-[13px] leading-[18px] text-[#525252]">
          Scanned locally on this device · No data left this machine
        </p>
      </div>
      <div class="flex shrink-0 gap-3">
        <Button variant="secondary" size="medium" @click="emit('rescan')">Re-scan</Button>
        <Button size="medium" @click="exportSelected">Export report</Button>
      </div>
    </div>

    <div class="flex flex-wrap gap-4 px-8 pb-6">
      <StatTile label="Paths scanned" :value="results.length" />
      <StatTile
        label="Files with findings"
        :value="filesWithFindings.length"
        clickable
        :active="statusFilter === 'has-findings'"
        @click="statusFilter = statusFilter === 'has-findings' ? 'all' : 'has-findings'"
      />
      <StatTile
        label="Emails found"
        :value="totalEmails"
        clickable
        :active="categoryFilter.email"
        @click="toggleCategory('email')"
      />
      <StatTile
        label="Phone numbers found"
        :value="totalPhones"
        clickable
        :active="categoryFilter.phone"
        @click="toggleCategory('phone')"
      />
    </div>

    <p v-if="results.length === 0" class="px-8 text-[#525252]">No files found.</p>
    <div v-else class="flex flex-col md:flex-row">
      <aside class="flex shrink-0 flex-col gap-6 py-2 pr-6 pl-8 md:w-[282px]">
        <div>
          <h3 class="mb-3 text-[12px] leading-[16px] font-semibold tracking-[0.32px] text-[#525252] uppercase">
            Status
          </h3>
          <div class="flex flex-col gap-4">
            <Checkbox
              :label="`All (${visibleResults.length})`"
              :model-value="statusFilter === 'all'"
              @update:model-value="statusFilter = 'all'"
            />
            <Checkbox
              :label="`Has findings (${filesWithFindings.length})`"
              :model-value="statusFilter === 'has-findings'"
              @update:model-value="statusFilter = 'has-findings'"
            />
            <Checkbox
              :label="`No findings (${filesWithNoFindings.length})`"
              :model-value="statusFilter === 'no-findings'"
              @update:model-value="statusFilter = 'no-findings'"
            />
          </div>
        </div>
        <div>
          <h3 class="mb-3 text-[12px] leading-[16px] font-semibold tracking-[0.32px] text-[#525252] uppercase">
            Category
          </h3>
          <div class="flex flex-col gap-4">
            <Checkbox :label="`Email · ${filesWithEmail.length} files`" v-model="categoryFilter.email" />
            <Checkbox :label="`Phone numbers · ${filesWithPhone.length} files`" v-model="categoryFilter.phone" />
            <Checkbox :label="`Other · ${totalOther} files`" v-model="categoryFilter.other" />
          </div>
        </div>
      </aside>

      <div class="flex min-w-0 flex-1 flex-col gap-4 py-2 pr-8 pb-10 pl-2">
        <div class="flex flex-wrap gap-3">
          <SearchInput v-model="search" placeholder="Search by file path" class="min-w-[240px] flex-1" />
          <SortSelect v-model="sort" :options="sortOptions" />
        </div>

        <BatchActionBar
          v-if="selected.size > 0"
          :count="selected.size"
          @redact="redactSelected"
          @export="exportSelected"
          @quarantine="quarantineSelected"
          @cancel="clearSelection"
        />

        <p v-if="filteredResults.length === 0" class="text-[#525252]">
          No files match these filters.
        </p>
        <List v-else title="Findings">
          <FindingsTable
            :files="filteredResults"
            :selected="selected"
            @toggle="toggleSelected"
            @toggle-all="toggleAllSelected"
          />
        </List>
      </div>
    </div>
  </section>
</template>
