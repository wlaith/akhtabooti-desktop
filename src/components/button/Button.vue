<script setup lang="ts">
withDefaults(
  defineProps<{ variant?: "primary" | "secondary" | "outline"; size?: "small" | "medium" | "large"; disabled?: boolean }>(),
  { variant: "primary", size: "large", disabled: false },
);
</script>

<template>
  <button
    :disabled="disabled"
    class="relative flex items-center whitespace-nowrap outline-none transition-colors disabled:cursor-not-allowed disabled:opacity-40"
    :class="[
      size === 'small'
        ? ['gap-1', 'px-2.5 py-1 text-[12px] leading-[16px]']
        : ['pl-4', $slots.icon ? 'pr-16' : 'pr-4', 'text-[14px] leading-[18px] tracking-[0.16px]', size === 'medium' ? 'py-[11px]' : 'py-[15px]'],
      variant === 'primary'
        ? 'bg-[#4b5cda] text-white hover:bg-[#3a48b0] active:bg-[#2e3a8c]'
        : variant === 'secondary'
          ? 'bg-[#393939] text-white hover:bg-[#4c4c4c] active:bg-[#6f6f6f]'
          : 'border border-[#4b5cda] text-[#4b5cda] hover:bg-[#e8e8e8] active:bg-[#e0e0e0]',
    ]"
  >
    <slot v-if="$slots.icon && size === 'small'" name="icon" />
    <slot />
    <span v-if="$slots.icon && size !== 'small'" class="absolute top-1/2 right-4 -translate-y-1/2">
      <slot name="icon" />
    </span>
  </button>
</template>
