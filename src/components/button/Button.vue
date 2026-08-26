<script setup lang="ts">
withDefaults(
  defineProps<{ variant?: "primary" | "secondary"; disabled?: boolean }>(),
  { variant: "primary", disabled: false },
);
</script>

<template>
  <button
    :disabled="disabled"
    class="relative flex items-center py-[15px] pl-4 text-[14px] leading-[18px] tracking-[0.16px] whitespace-nowrap outline-none transition-colors disabled:cursor-not-allowed disabled:opacity-40"
    :class="[
      $slots.icon ? 'pr-16' : 'pr-4',
      variant === 'primary'
        ? 'bg-[#4b5cda] text-white hover:bg-[#3a48b0] active:bg-[#2e3a8c]'
        : 'border border-[#4b5cda] text-[#4b5cda] hover:bg-[#4b5cda]/10 active:bg-[#4b5cda]/20',
    ]"
  >
    <slot />
    <span v-if="$slots.icon" class="absolute top-1/2 right-4 -translate-y-1/2">
      <slot name="icon" />
    </span>
  </button>
</template>
