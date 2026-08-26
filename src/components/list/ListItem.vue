<script setup lang="ts">
defineSlots<{
  icon?: () => unknown;
  default: () => unknown;
  actions?: () => unknown;
}>();
</script>

<template>
  <div class="flex items-center gap-4 bg-white px-4 py-[14px]">
    <span v-if="$slots.icon" class="flex shrink-0 items-center text-[#525252]">
      <slot name="icon" />
    </span>
    <div class="min-w-0 flex-1 text-[14px] leading-[20px] tracking-[0.16px] text-[#161616]">
      <slot />
    </div>
    <span v-if="$slots.actions" class="shrink-0">
      <slot name="actions" />
    </span>
  </div>
</template>
