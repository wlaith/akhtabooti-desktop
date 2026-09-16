<script setup lang="ts">
import Icon from "../icon/Icon.vue";

defineEmits<{ (e: "close"): void }>();
</script>

<template>
  <div class="fixed inset-0 z-30 flex items-center justify-center bg-black/40" @click.self="$emit('close')">
    <div
      class="w-full max-w-[400px] bg-white p-6 shadow-xl"
      role="dialog"
      aria-modal="true"
      aria-labelledby="about-title"
    >
      <div class="mb-4 flex items-start justify-between">
        <div class="flex items-center gap-3">
          <img src="/logo.png" alt="" class="h-8 w-8 object-contain" />
          <div>
            <h2 id="about-title" class="text-[18px] font-semibold text-[#161616]">Akhtabooti</h2>
            <p class="text-[13px] text-[#525252]">Version 0.1.0 (placeholder)</p>
          </div>
        </div>
        <button
          type="button"
          class="text-[#525252] outline-none hover:text-[#161616]"
          aria-label="Close"
          @click="$emit('close')"
        >
          <Icon name="close" :size="16" />
        </button>
      </div>

      <p class="mb-4 text-[14px] leading-[20px] text-[#161616]">
        Placeholder description: Akhtabooti scans local files and folders for personally
        identifiable information (PII) such as email addresses and phone numbers.
      </p>

      <p class="mb-4 flex items-start gap-2 rounded bg-[#f4f4f4] p-3 text-[13px] leading-[18px] text-[#161616]">
        🔒 Placeholder privacy statement: All scanning happens locally on this device.
        No file contents or findings ever leave this machine.
      </p>

      <p class="text-[12px] text-[#525252]">
        Placeholder licence · © 2026 · <a href="#" class="text-[#4b5cda] underline">Report an issue</a>
      </p>
    </div>
  </div>
</template>
