<script setup lang="ts">
import { ref } from "vue";
import type { FilePIIs } from "../../composables/useScan";
import Icon from "../icon/Icon.vue";
import Checkbox from "../checkbox/Checkbox.vue";

const props = defineProps<{
  files: FilePIIs[];
  selected: Set<string>;
  scanningFiles?: Set<string>;
}>();

const emit = defineEmits<{
  (e: "toggle", filename: string, value: boolean): void;
  (e: "toggle-all", value: boolean): void;
}>();

const openRows = ref(new Set<string>());
const GRID_COLS = "grid-cols-[48px_20px_350px_350px_350px]";

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

function findingCount(file: FilePIIs) {
  return file.email_accounts.length + file.phone_numbers.length + file.other_piis.length;
}

const allSelected = () =>
  props.files.length > 0 && props.files.every((f) => props.selected.has(f.filename));
</script>

<template>
  <div class="w-full overflow-x-auto">
    <div class="min-w-[1118px]">
      <div :class="['grid items-start bg-[#e0e0e0]', GRID_COLS]">
        <span class="flex justify-center pt-4 pb-8 text-[#161616]">
          <Icon name="chevron-down" />
        </span>
        <span class="pt-[14px] pb-[30px]"><Checkbox :model-value="allSelected()" @update:model-value="emit('toggle-all', $event)" /></span>
        <span class="py-4 pr-2 pl-4 text-[14px] leading-[18px] font-semibold tracking-[0.16px] text-[#161616]">File path</span>
        <span class="py-4 pr-2 pl-4 text-[14px] leading-[18px] font-semibold tracking-[0.16px] text-[#161616]">Findings</span>
        <span class="py-4 pr-2 pl-4 text-[14px] leading-[18px] font-semibold tracking-[0.16px] text-[#161616]">Status</span>
      </div>

      <div v-for="file in files" :key="file.filename" class="border-b border-[#e0e0e0]">
        <div
          :class="[
            'grid items-start',
            GRID_COLS,
            isScanning(file.filename) ? 'opacity-50' : '',
            selected.has(file.filename) ? 'bg-[#8d8d8d]/20' : 'bg-white',
          ]"
        >
          <button
            type="button"
            class="flex justify-center pt-4 pb-8 text-[#525252] outline-none disabled:cursor-not-allowed"
            :disabled="isScanning(file.filename)"
            :aria-expanded="openRows.has(file.filename)"
            :aria-label="openRows.has(file.filename) ? 'Collapse row' : 'Expand row'"
            @click="toggleOpen(file.filename)"
          >
            <Icon :name="openRows.has(file.filename) ? 'chevron-up' : 'chevron-down'" />
          </button>
          <span class="pt-[14px] pb-[30px]">
            <Checkbox
              :model-value="selected.has(file.filename)"
              :disabled="isScanning(file.filename)"
              @update:model-value="emit('toggle', file.filename, $event)"
            />
          </span>
          <span class="min-w-0 truncate py-4 pr-2 pl-4 text-[14px] leading-[18px] tracking-[0.16px] text-[#161616]">
            {{ file.filename }}
          </span>
          <span class="py-4 pr-2 pl-4 text-[14px] leading-[18px] tracking-[0.16px] text-[#161616]">
            {{ isScanning(file.filename) ? "—" : hasFindings(file) ? `${findingCount(file)} findings` : "No findings" }}
          </span>
          <span
            class="py-4 pr-2 pl-4 text-[14px] leading-[18px] tracking-[0.16px]"
            :class="isScanning(file.filename) ? 'text-[#8d8d8d]' : 'text-[#161616]'"
          >
            {{ isScanning(file.filename) ? "Scanning…" : "Reviewed" }}
          </span>
        </div>
        <div
          v-if="openRows.has(file.filename) && !isScanning(file.filename)"
          class="flex flex-col gap-4 bg-white py-4 pr-4 pl-[88px] text-[14px] leading-[18px] tracking-[0.16px] text-[#161616]"
        >
          <template v-if="hasFindings(file)">
            <div v-if="file.email_accounts.length">
              <div class="mb-1 font-semibold">Emails ({{ file.email_accounts.length }})</div>
              <ul class="list-disc space-y-0.5 pl-5">
                <li v-for="email in file.email_accounts" :key="email" class="break-all">
                  {{ email }}
                </li>
              </ul>
            </div>
            <div v-if="file.phone_numbers.length">
              <div class="mb-1 font-semibold">Phone numbers ({{ file.phone_numbers.length }})</div>
              <ul class="list-disc space-y-0.5 pl-5">
                <li v-for="phone in file.phone_numbers" :key="phone">{{ phone }}</li>
              </ul>
            </div>
            <div v-if="file.other_piis.length">
              <div class="mb-1 font-semibold">Other</div>
              <div class="flex flex-wrap gap-2">
                <span
                  v-for="tag in file.other_piis"
                  :key="tag"
                  class="rounded-full bg-red-100 px-3 py-0.5 text-sm text-red-800"
                >
                  {{ tag }}
                </span>
              </div>
            </div>
          </template>
          <p v-else class="text-green-600">No PII detected in this file</p>
        </div>
      </div>
    </div>
  </div>
</template>
