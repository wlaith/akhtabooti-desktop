<script setup lang="ts">
import Icon from "../icon/Icon.vue";

export type SortOption = "most" | "fewest" | "az" | "za";

defineProps<{ modelValue: SortOption; options: { value: SortOption; label: string }[] }>();
defineEmits<{ (e: "update:modelValue", value: SortOption): void }>();
</script>

<template>
  <label class="flex shrink-0 flex-col text-[14px] leading-[18px] tracking-[0.16px] text-text-secondary">
    Sort by
    <span class="relative mt-1 block h-12 min-w-[200px] border-0 border-b border-text-tertiary bg-surface">
      <select
        :value="modelValue"
        class="h-12 w-full appearance-none bg-transparent py-[15px] pr-9 pl-4 text-[14px] leading-[18px] tracking-[0.16px] text-text-primary outline-none focus:border-action-primary"
        @change="$emit('update:modelValue', ($event.target as HTMLSelectElement).value as SortOption)"
      >
        <option v-for="opt in options" :key="opt.value" :value="opt.value">{{ opt.label }}</option>
      </select>
      <span class="pointer-events-none absolute top-1/2 right-4 -translate-y-1/2 text-text-primary">
        <Icon name="chevron-down" />
      </span>
    </span>
  </label>
</template>
