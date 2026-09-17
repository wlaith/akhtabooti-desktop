<script setup lang="ts">
defineProps<{ title?: string }>();
</script>

<template>
  <div class="w-full text-left">
    <div
      v-if="title"
      class="flex items-center gap-2 border-b border-text-primary/12 bg-neutral-bg px-4 py-[15px]"
    >
      <span class="text-[14px] leading-[18px] font-semibold tracking-[0.16px] text-text-primary">
        {{ title }}
      </span>
      <slot name="title-action" />
    </div>
    <div class="divide-y divide-text-primary/12 border-b border-text-primary/12">
      <slot />
    </div>
  </div>
</template>
