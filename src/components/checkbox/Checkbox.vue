<script setup lang="ts">
withDefaults(defineProps<{ modelValue: boolean; label?: string; disabled?: boolean }>(), {
  disabled: false,
});
defineEmits<{ (e: "update:modelValue", value: boolean): void }>();
</script>

<template>
  <label
    class="inline-flex items-center gap-2 text-[14px] leading-[18px] tracking-[0.16px] text-text-primary"
    :class="disabled ? 'cursor-not-allowed opacity-40' : 'cursor-pointer'"
  >
    <span class="relative flex h-4 w-4 shrink-0 items-center justify-center">
      <input
        type="checkbox"
        class="absolute inset-0 h-4 w-4 cursor-pointer opacity-0"
        :checked="modelValue"
        :disabled="disabled"
        @click.stop
        @change="$emit('update:modelValue', ($event.target as HTMLInputElement).checked)"
      />
      <span
        class="pointer-events-none absolute inset-0 border border-text-primary"
        :class="modelValue ? 'bg-text-primary' : 'bg-surface'"
      />
      <svg
        v-if="modelValue"
        class="pointer-events-none relative h-2.5 w-2.5 text-text-inverse"
        viewBox="0 0 16 16"
        fill="none"
        aria-hidden="true"
      >
        <path
          d="M3 8.5L6.5 12L13 4.5"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="square"
          stroke-linejoin="miter"
        />
      </svg>
    </span>
    <span v-if="label || $slots.default"
      ><slot>{{ label }}</slot></span
    >
  </label>
</template>
