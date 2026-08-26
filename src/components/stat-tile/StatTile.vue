<script setup lang="ts">
defineProps<{ label: string; value: number | string }>();
</script>

<template>
  <div class="flex flex-1 flex-col gap-1">
    <span class="text-[12px] text-[#525252]">{{ label }}</span>
    <span class="text-[32px] font-semibold text-[#161616]">{{ value }}</span>
  </div>
</template>
