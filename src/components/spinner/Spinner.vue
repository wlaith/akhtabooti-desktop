<script setup lang="ts">
withDefaults(defineProps<{ size?: number }>(), { size: 16 });
</script>

<template>
  <span
    class="inline-block shrink-0 animate-spin rounded-full border-2 border-[#c6c6c6] border-t-[#4b5cda]"
    :style="{ width: `${size}px`, height: `${size}px` }"
    role="status"
    aria-label="Scanning"
  />
</template>
