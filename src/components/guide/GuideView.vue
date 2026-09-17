<script setup lang="ts">
import Icon from "../icon/Icon.vue";

defineEmits<{ (e: "close"): void }>();

const sections = [
  {
    title: "1. Choose what to scan",
    body: "Add one or more files or folders to the scan list. You can mix files and folders in the same scan, and remove anything you added by mistake before you start.",
  },
  {
    title: "2. Run the scan",
    body: "Start the scan and watch progress for each path. Scanning happens entirely on this device — nothing is uploaded. You can cancel at any point without leaving anything behind.",
  },
  {
    title: "3. Review findings",
    body: "Filter by category, search by file path, and open a file to see which identifiers were found in it. Paths that could not be read are listed separately so nothing is silently skipped.",
  },
  {
    title: "4. Export a report",
    body: "Export the selected findings — or all of them — as a JSON report you can share with your team or keep for your records. You choose where it is saved.",
  },
];
</script>

<template>
  <section class="flex h-full flex-col overflow-y-auto p-8 text-left">
    <div class="mb-6 flex items-start justify-between">
      <h2 class="text-[24px] leading-[32px] font-semibold text-text-primary">
        How to use Akhtabooti
      </h2>
      <button
        type="button"
        class="flex h-8 w-8 items-center justify-center text-text-secondary outline-none hover:bg-text-primary/8 hover:text-text-primary"
        aria-label="Back to scan"
        @click="$emit('close')"
      >
        <Icon name="close" :size="16" />
      </button>
    </div>

    <div class="flex max-w-[640px] flex-col gap-6">
      <div v-for="section in sections" :key="section.title">
        <h3 class="mb-1 text-[16px] font-semibold text-text-primary">{{ section.title }}</h3>
        <p class="text-[14px] leading-[20px] text-text-secondary">{{ section.body }}</p>
      </div>
    </div>
  </section>
</template>
