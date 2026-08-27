<script setup lang="ts">
withDefaults(
  defineProps<{ variant?: "primary" | "secondary"; size?: "medium" | "large"; disabled?: boolean }>(),
  { variant: "primary", size: "large", disabled: false },
);
</script>

<template>
  <button
    :disabled="disabled"
    class="relative flex items-center pl-4 text-[14px] leading-[18px] tracking-[0.16px] whitespace-nowrap outline-none transition-colors disabled:cursor-not-allowed disabled:opacity-40"
    :class="[
      size === 'medium' ? 'py-[11px]' : 'py-[15px]',
      $slots.icon ? 'pr-16' : 'pr-4',
      variant === 'primary'
        ? 'bg-[#4b5cda] text-white hover:bg-[#3a48b0] active:bg-[#2e3a8c]'
        : 'bg-[#393939] text-white hover:bg-[#4c4c4c] active:bg-[#6f6f6f]',
    ]"
  >
    <slot />
    <span v-if="$slots.icon" class="absolute top-1/2 right-4 -translate-y-1/2">
      <slot name="icon" />
    </span>
  </button>
</template>
