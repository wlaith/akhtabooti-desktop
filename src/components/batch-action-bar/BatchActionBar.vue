<script setup lang="ts">
defineProps<{ count: number }>();
defineEmits<{
  (e: "redact"): void;
  (e: "export"): void;
  (e: "quarantine"): void;
  (e: "cancel"): void;
}>();
</script>

<template>
  <div class="sticky top-0 z-10 flex items-center bg-[#4b5cda] text-white">
    <span class="flex-1 px-4 py-[15px] text-[14px] leading-[18px] tracking-[0.16px]">
      {{ count }} selected
    </span>
    <div class="flex items-center">
      <button
        type="button"
        class="cursor-pointer px-4 py-[15px] text-[14px] leading-[18px] tracking-[0.16px] hover:bg-white/10"
        @click="$emit('redact')"
      >
        Redact
      </button>
      <button
        type="button"
        class="cursor-pointer px-4 py-[15px] text-[14px] leading-[18px] tracking-[0.16px] hover:bg-white/10"
        @click="$emit('export')"
      >
        Export
      </button>
      <button
        type="button"
        class="cursor-pointer px-4 py-[15px] text-[14px] leading-[18px] tracking-[0.16px] hover:bg-white/10"
        @click="$emit('quarantine')"
      >
        Quarantine
      </button>
      <span class="mx-2 h-5 w-px bg-white/40" />
      <button
        type="button"
        class="cursor-pointer px-4 py-[15px] text-[14px] leading-[18px] tracking-[0.16px] hover:bg-white/10"
        @click="$emit('cancel')"
      >
        Cancel
      </button>
    </div>
  </div>
</template>
