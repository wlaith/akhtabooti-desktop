<script setup lang="ts">
import { computed, reactive, ref } from "vue";
import { invoke } from "@tauri-apps/api/core";
import { save } from "@tauri-apps/plugin-dialog";
import type { FilePIIs } from "../../composables/useScan";
import List from "../list/List.vue";
import StatTile from "../stat-tile/StatTile.vue";
import Button from "../button/Button.vue";
import Checkbox from "../checkbox/Checkbox.vue";
import Tooltip from "../tooltip/Tooltip.vue";
import Icon from "../icon/Icon.vue";
import SearchInput from "../search-input/SearchInput.vue";
import SortSelect, { type SortOption } from "../sort-select/SortSelect.vue";
import BatchActionBar from "../batch-action-bar/BatchActionBar.vue";
import FindingsTable from "../findings-table/FindingsTable.vue";
import FailedPathsTable from "../findings-table/FailedPathsTable.vue";

const props = withDefaults(
  defineProps<{ results: FilePIIs[]; pathErrors?: Record<string, string> }>(),
  { pathErrors: () => ({}) },
);
const emit = defineEmits<{ (e: "rescan"): void }>();

const failedPaths = computed(() => Object.entries(props.pathErrors));

function hasFindings(file: FilePIIs) {
  return (
    file.email_accounts.length > 0 ||
    file.phone_numbers.length > 0 ||
    file.other_piis.length > 0
  );
}

const visibleResults = computed(() => props.results);

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

async function exportSelected() {
  const target = selected.size > 0 ? visibleResults.value.filter((f) => selected.has(f.filename)) : visibleResults.value;

  const path = await save({
    defaultPath: "scan-report.json",
    filters: [{ name: "JSON", extensions: ["json"] }],
  });
  if (!path) return;

  await invoke("write_file", { path, contents: JSON.stringify(target, null, 2) });
}
</script>

<template>
  <section class="w-full text-left">
    <div class="mb-6 flex flex-wrap items-start justify-between gap-6">
      <div>
        <h2 class="text-[28px] leading-[36px] font-semibold text-text-primary">Scan Report</h2>
        <p class="mt-1 text-[13px] leading-[18px] text-text-secondary">
          Scanned locally on this device · No data left this machine
        </p>
      </div>
      <div class="flex shrink-0 gap-3">
        <Button variant="secondary" size="medium" @click="emit('rescan')">Re-scan</Button>
        <Button size="medium" @click="exportSelected">Export report</Button>
      </div>
    </div>

    <div class="mb-6 flex flex-wrap gap-4">
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

    <p v-if="results.length === 0" class="text-text-secondary">No files found.</p>
    <div v-else class="flex flex-col md:flex-row">
      <aside class="flex shrink-0 flex-col gap-4 md:w-[282px] md:gap-6 md:pr-6">
        <div>
          <h3 class="mb-2 text-[12px] leading-[16px] font-semibold tracking-[0.32px] text-text-secondary uppercase md:mb-3">
            Status
          </h3>
          <div class="flex flex-col gap-2 md:gap-4">
            <Tooltip wrap text="Show every scanned file">
              <Checkbox :model-value="statusFilter === 'all'" @update:model-value="statusFilter = 'all'">
                <span class="inline-flex items-center gap-1">All ({{ visibleResults.length }}) <Icon name="information" :size="12" class="text-text-secondary" /></span>
              </Checkbox>
            </Tooltip>
            <Tooltip wrap text="Show only files where PII was detected">
              <Checkbox :model-value="statusFilter === 'has-findings'" @update:model-value="statusFilter = 'has-findings'">
                <span class="inline-flex items-center gap-1">Has findings ({{ filesWithFindings.length }}) <Icon name="information" :size="12" class="text-text-secondary" /></span>
              </Checkbox>
            </Tooltip>
            <Tooltip wrap text="Show only files with no PII detected">
              <Checkbox :model-value="statusFilter === 'no-findings'" @update:model-value="statusFilter = 'no-findings'">
                <span class="inline-flex items-center gap-1">No findings ({{ filesWithNoFindings.length }}) <Icon name="information" :size="12" class="text-text-secondary" /></span>
              </Checkbox>
            </Tooltip>
          </div>
        </div>
        <div>
          <h3 class="mb-2 text-[12px] leading-[16px] font-semibold tracking-[0.32px] text-text-secondary uppercase md:mb-3">
            Category
          </h3>
          <div class="flex flex-col gap-2 md:gap-4">
            <Tooltip wrap text="Show files containing email addresses">
              <Checkbox v-model="categoryFilter.email">
                <span class="inline-flex items-center gap-1">Email · {{ filesWithEmail.length }} files <Icon name="information" :size="12" class="text-text-secondary" /></span>
              </Checkbox>
            </Tooltip>
            <Tooltip wrap text="Show files containing phone numbers">
              <Checkbox v-model="categoryFilter.phone">
                <span class="inline-flex items-center gap-1">Phone numbers · {{ filesWithPhone.length }} files <Icon name="information" :size="12" class="text-text-secondary" /></span>
              </Checkbox>
            </Tooltip>
            <Tooltip wrap text="Show files containing other detected PII">
              <Checkbox v-model="categoryFilter.other">
                <span class="inline-flex items-center gap-1">Other · {{ totalOther }} files <Icon name="information" :size="12" class="text-text-secondary" /></span>
              </Checkbox>
            </Tooltip>
          </div>
        </div>
      </aside>

      <div class="flex min-w-0 flex-1 flex-col gap-4 pb-8 md:border-l md:border-text-primary/12 md:pl-6">
        <div class="flex flex-wrap gap-3">
          <SearchInput v-model="search" placeholder="Search by file path" class="min-w-[240px] flex-1" />
          <SortSelect v-model="sort" :options="sortOptions" />
        </div>

        <BatchActionBar
          v-if="selected.size > 0"
          :count="selected.size"
          @export="exportSelected"
          @cancel="clearSelection"
        />

        <p v-if="filteredResults.length === 0" class="text-text-secondary">
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

        <List v-if="failedPaths.length > 0" :title="`Couldn't be scanned (${failedPaths.length})`">
          <FailedPathsTable :entries="failedPaths" />
        </List>
      </div>
    </div>
  </section>
</template>
