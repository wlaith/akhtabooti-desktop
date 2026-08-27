<script setup lang="ts">
defineProps<{ modelValue: string; placeholder?: string }>();
defineEmits<{ (e: "update:modelValue", value: string): void }>();
</script>

<template>
  <div class="relative h-12 w-full bg-white">
    <svg
      class="pointer-events-none absolute top-1/2 left-4 h-4 w-4 -translate-y-1/2 text-[#525252]"
      viewBox="0 0 16 16"
      fill="none"
      aria-hidden="true"
    >
      <circle cx="6.5" cy="6.5" r="5" stroke="currentColor" stroke-width="1.3" />
      <line x1="10.2" y1="10.2" x2="14" y2="14" stroke="currentColor" stroke-width="1.3" />
    </svg>
    <input
      type="text"
      :value="modelValue"
      :placeholder="placeholder"
      class="h-12 w-full border-0 border-b border-[#8d8d8d] bg-transparent pr-4 pl-12 text-[14px] leading-[18px] tracking-[0.16px] text-[#161616] outline-none placeholder:text-[#a8a8a8] focus:border-[#4b5cda]"
      @input="$emit('update:modelValue', ($event.target as HTMLInputElement).value)"
    />
  </div>
</template>
