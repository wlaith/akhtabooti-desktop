<script setup lang="ts">
defineProps<{ title?: string }>();
</script>

<template>
  <div class="w-full text-left">
    <div
      v-if="title"
      class="flex items-center gap-2 border-b border-[#e0e0e0] bg-[#f4f4f4] px-4 py-[15px]"
    >
      <span class="text-[14px] leading-[18px] font-semibold tracking-[0.16px] text-[#161616]">
        {{ title }}
      </span>
      <slot name="title-action" />
    </div>
    <div class="divide-y divide-[#e0e0e0] border-b border-[#e0e0e0]">
      <slot />
    </div>
  </div>
</template>
