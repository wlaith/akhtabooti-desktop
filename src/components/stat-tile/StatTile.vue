<script setup lang="ts">
withDefaults(defineProps<{ label: string; value: number | string; clickable?: boolean; active?: boolean }>(), {
  clickable: false,
  active: false,
});
defineEmits<{ (e: "click"): void }>();
</script>

<template>
  <component
    :is="clickable ? 'button' : 'div'"
    type="button"
    class="relative flex min-w-[180px] flex-1 flex-col bg-[#f4f4f4] p-4 pb-12 text-left outline-none"
    :class="clickable ? (active ? 'ring-2 ring-inset ring-[#4b5cda]' : 'cursor-pointer hover:bg-[#e8e8e8]') : ''"
    :aria-pressed="clickable ? active : undefined"
    @click="clickable && $emit('click')"
  >
    <span class="text-[28px] leading-[36px] font-normal text-[#161616]">{{ value }}</span>
    <span class="text-[14px] leading-[18px] tracking-[0.16px] text-[#161616]">{{ label }}</span>
    <svg
      v-if="clickable"
      class="absolute right-[3px] bottom-[3px] h-5 w-5 text-[#4b5cda]"
      viewBox="0 0 20 20"
      fill="none"
      aria-hidden="true"
    >
      <path d="M3 10h13M11 5l5 5-5 5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round" />
    </svg>
  </component>
</template>
