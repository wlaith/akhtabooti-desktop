<script setup lang="ts">
defineSlots<{
  icon?: () => unknown;
  default: () => unknown;
  actions?: () => unknown;
}>();
</script>

<template>
  <div class="flex items-center gap-4 bg-surface px-4 py-[14px]">
    <span v-if="$slots.icon" class="flex shrink-0 items-center text-text-secondary">
      <slot name="icon" />
    </span>
    <div class="min-w-0 flex-1 text-[14px] leading-[20px] tracking-[0.16px] text-text-primary">
      <slot />
    </div>
    <span v-if="$slots.actions" class="shrink-0">
      <slot name="actions" />
    </span>
  </div>
</template>
