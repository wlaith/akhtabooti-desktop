<script setup lang="ts">
import { reactive, ref } from "vue";
import type { FilePIIs } from "../../composables/useScan";
import Icon from "../icon/Icon.vue";
import Checkbox from "../checkbox/Checkbox.vue";
import Tooltip from "../tooltip/Tooltip.vue";

const props = defineProps<{
  files: FilePIIs[];
  selected: Set<string>;
  scanningFiles?: Set<string>;
}>();

const emit = defineEmits<{
  (e: "toggle", filename: string, value: boolean): void;
  (e: "toggle-all", value: boolean): void;
}>();

type ConfirmedValue = { key: string; icon: "email-user" | "phone"; label: string; value: string };

const openRows = ref(new Set<string>());
const revealedValues = reactive(new Set<string>());
const copiedValue = ref<string | null>(null);
const GRID_COLS = "grid-cols-[40px_24px_minmax(0,1fr)_120px_130px] gap-3";

const FILE_ICONS: Record<string, "document-pdf" | "document-doc" | "document-xls" | "document-html" | "document-json" | "document-txt"> = {
  pdf: "document-pdf",
  doc: "document-doc",
  docx: "document-doc",
  xls: "document-xls",
  xlsx: "document-xls",
  html: "document-html",
  htm: "document-html",
  json: "document-json",
  txt: "document-txt",
};

function fileIcon(filename: string) {
  const ext = filename.split(".").pop()?.toLowerCase() ?? "";
  return FILE_ICONS[ext] ?? "document";
}

function toggleOpen(filename: string) {
  if (openRows.value.has(filename)) openRows.value.delete(filename);
  else openRows.value.add(filename);
}

function isScanning(filename: string) {
  return props.scanningFiles?.has(filename) ?? false;
}

function hasFindings(file: FilePIIs) {
  return (
    file.email_accounts.length > 0 ||
    file.phone_numbers.length > 0 ||
    file.other_piis.length > 0
  );
}

function confirmedValues(file: FilePIIs): ConfirmedValue[] {
  return [
    ...file.email_accounts.map((value) => ({ key: `${file.filename}:email:${value}`, icon: "email-user" as const, label: "Email", value })),
    ...file.phone_numbers.map((value) => ({ key: `${file.filename}:phone:${value}`, icon: "phone" as const, label: "Phone number", value })),
  ];
}

function findingCount(file: FilePIIs) {
  return file.email_accounts.length + file.phone_numbers.length + file.other_piis.length;
}

function maskValue(value: string) {
  if (value.length <= 4) return "•".repeat(value.length);
  return `${value.slice(0, 2)}${"•".repeat(Math.max(value.length - 4, 3))}${value.slice(-2)}`;
}

function toggleReveal(key: string) {
  if (revealedValues.has(key)) revealedValues.delete(key);
  else revealedValues.add(key);
}

async function copyValue(key: string, value: string) {
  await navigator.clipboard.writeText(value);
  copiedValue.value = key;
  setTimeout(() => {
    if (copiedValue.value === key) copiedValue.value = null;
  }, 1500);
}

const allSelected = () =>
  props.files.length > 0 && props.files.every((f) => props.selected.has(f.filename));
</script>

<template>
  <div class="w-full overflow-x-auto">
    <div :class="['sticky top-0 z-10 grid min-w-fit items-center bg-neutral-bg', GRID_COLS]">
      <span />
      <Checkbox :model-value="allSelected()" @update:model-value="emit('toggle-all', $event)" />
      <span class="min-w-0 truncate py-4 pr-2 pl-1 text-[14px] leading-[18px] font-semibold tracking-[0.16px] text-text-secondary">File path</span>
      <span class="truncate py-4 pr-2 pl-1 text-[14px] leading-[18px] font-semibold tracking-[0.16px] text-text-secondary">Findings</span>
      <span class="truncate py-4 pr-2 pl-1 text-[14px] leading-[18px] font-semibold tracking-[0.16px] text-text-secondary">Status</span>
    </div>

    <div v-for="file in files" :key="file.filename" class="border-b border-text-primary/12">
      <div
        :class="[
          'grid min-w-fit items-center',
          GRID_COLS,
          isScanning(file.filename) ? 'opacity-50' : '',
          selected.has(file.filename) ? 'bg-text-tertiary/20' : 'bg-surface hover:bg-neutral-bg',
        ]"
      >
        <button
          type="button"
          class="flex h-10 w-10 items-center justify-center rounded text-text-secondary outline-none hover:bg-text-primary/8 disabled:cursor-not-allowed disabled:hover:bg-transparent"
          :disabled="isScanning(file.filename)"
          :aria-expanded="openRows.has(file.filename)"
          :aria-label="openRows.has(file.filename) ? 'Collapse row' : 'Expand row'"
          @click="toggleOpen(file.filename)"
        >
          <Icon :name="openRows.has(file.filename) ? 'chevron-up' : 'chevron-down'" />
        </button>
        <Checkbox
          :model-value="selected.has(file.filename)"
          :disabled="isScanning(file.filename)"
          @update:model-value="emit('toggle', file.filename, $event)"
        />
        <span class="flex min-w-0 items-center gap-3 py-3 pr-2 pl-1">
          <Icon :name="fileIcon(file.filename)" class="shrink-0 text-text-secondary" />
          <span
            class="min-w-0 truncate text-[14px] leading-[18px] tracking-[0.16px] text-text-primary"
            :title="file.filename"
          >
            {{ file.filename }}
          </span>
        </span>
        <span class="py-3 pr-2 pl-1 text-[14px] leading-[18px] tracking-[0.16px] text-text-primary">
          {{ isScanning(file.filename) ? "—" : hasFindings(file) ? `${findingCount(file)} findings` : "No findings" }}
        </span>
        <span class="flex items-center gap-2 py-3 pr-2 pl-1 text-[14px] leading-[18px] tracking-[0.16px]">
          <Icon
            :name="isScanning(file.filename) ? 'hourglass' : 'checkmark-outline'"
            :class="isScanning(file.filename) ? 'text-text-tertiary' : 'text-success'"
          />
          <span :class="isScanning(file.filename) ? 'text-text-tertiary' : 'text-text-primary'">
            {{ isScanning(file.filename) ? "Scanning…" : "Reviewed" }}
          </span>
        </span>
      </div>

      <div
        v-if="openRows.has(file.filename) && !isScanning(file.filename)"
        class="border-l-4 border-text-primary/20 bg-neutral-bg py-5 pr-6 pl-5"
      >
        <div v-if="hasFindings(file)" class="grid grid-cols-3 gap-6 bg-surface p-4">
          <div v-if="confirmedValues(file).length" class="col-span-2 min-w-0">
            <div class="flex items-center gap-2 border-b border-text-primary/12 px-4 py-[15px]">
              <span class="text-[14px] leading-[18px] font-semibold tracking-[0.16px] text-text-primary">
                Confirmed values
              </span>
              <Tooltip text="Literal values found in this file and matched with high confidence">
                <Icon name="information" :size="16" />
              </Tooltip>
            </div>
            <ul>
              <li
                v-for="item in confirmedValues(file)"
                :key="item.key"
                class="flex items-center gap-4 border-b border-text-primary/12 px-4 py-[14px] last:border-b-0"
              >
                <Icon :name="item.icon" class="shrink-0 text-text-secondary" />
                <span class="min-w-0 flex-1 truncate font-mono text-[14px] leading-[20px] tracking-[0.16px] text-text-primary">
                  {{ revealedValues.has(item.key) ? item.value : maskValue(item.value) }}
                </span>
                <span class="flex shrink-0 items-center gap-2 text-text-secondary">
                  <button
                    type="button"
                    class="flex h-8 w-8 items-center justify-center rounded outline-none hover:bg-text-primary/8 hover:text-text-primary"
                    :aria-label="revealedValues.has(item.key) ? `Hide ${item.label.toLowerCase()}` : `Reveal ${item.label.toLowerCase()}`"
                    @click="toggleReveal(item.key)"
                  >
                    <Icon :name="revealedValues.has(item.key) ? 'view-off' : 'view'" />
                  </button>
                  <button
                    type="button"
                    class="flex h-8 w-8 items-center justify-center rounded outline-none hover:bg-text-primary/8 hover:text-text-primary"
                    :aria-label="`Copy ${item.label.toLowerCase()}`"
                    @click="copyValue(item.key, item.value)"
                  >
                    <Icon :name="copiedValue === item.key ? 'checkmark-outline' : 'copy'" />
                  </button>
                </span>
              </li>
            </ul>
          </div>

          <div v-if="file.other_piis.length" :class="confirmedValues(file).length ? 'min-w-0' : 'col-span-3 min-w-0'">
            <div class="flex items-center gap-2 py-[15px]">
              <span class="text-[14px] leading-[18px] font-semibold tracking-[0.16px] text-text-primary">
                Detected categories
              </span>
              <Tooltip text="Categories inferred from keywords in this file; review before treating as confirmed">
                <Icon name="information" :size="16" />
              </Tooltip>
            </div>
            <div class="flex flex-wrap gap-2">
              <span
                v-for="tag in file.other_piis"
                :key="tag"
                class="rounded-full bg-text-primary/12 px-3 py-1 text-[12px] leading-4 tracking-[0.32px] text-text-primary"
              >
                {{ tag }}
              </span>
            </div>
          </div>
        </div>
        <div v-else class="flex flex-col items-center gap-2 bg-surface px-4 py-10 text-center">
          <Icon name="checkmark-outline" :size="24" class="text-success" />
          <p class="text-[14px] leading-[18px] tracking-[0.16px] text-text-primary">
            No confirmed values or categories detected in this file
          </p>
        </div>
      </div>
    </div>
  </div>
</template>
