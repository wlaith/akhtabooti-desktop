<script setup lang="ts">
import { ref, onMounted } from "vue";
import { getVersion } from "@tauri-apps/api/app";
import { openUrl } from "@tauri-apps/plugin-opener";
import Icon from "../icon/Icon.vue";

defineEmits<{ (e: "close"): void }>();

const ISSUES_URL = "https://github.com/wlaith/akhtabooti-desktop/issues";

const version = ref("");

onMounted(async () => {
  version.value = await getVersion();
});
</script>

<template>
  <div
    class="fixed inset-0 z-30 flex items-center justify-center bg-black/40"
    @click.self="$emit('close')"
  >
    <div
      class="w-full max-w-[400px] bg-surface p-6 shadow-xl"
      role="dialog"
      aria-modal="true"
      aria-labelledby="about-title"
    >
      <div class="mb-4 flex items-start justify-between">
        <div class="flex items-center gap-3">
          <img src="/logo.png" alt="" class="h-8 w-8 object-contain" />
          <div>
            <h2 id="about-title" class="text-[18px] font-semibold text-text-primary">Akhtabooti</h2>
            <p v-if="version" class="text-[13px] text-text-secondary">Version {{ version }}</p>
          </div>
        </div>
        <button
          type="button"
          class="text-text-secondary outline-none hover:text-text-primary"
          aria-label="Close"
          @click="$emit('close')"
        >
          <Icon name="close" :size="16" />
        </button>
      </div>

      <p class="mb-4 text-[14px] leading-[20px] text-text-primary">
        Akhtabooti scans local files and folders for personally identifiable information such as
        email addresses and phone numbers, so you know what personal data you are holding before you
        share or archive it.
      </p>

      <p
        class="mb-4 flex items-start gap-2 rounded bg-neutral-bg p-3 text-[13px] leading-[18px] text-text-primary"
      >
        🔒 All scanning happens on this device. Akhtabooti makes no network requests — no file
        contents and no findings ever leave this machine.
      </p>

      <p class="text-[12px] text-text-secondary">
        Apache-2.0 · © 2026 JOSA ·
        <button
          type="button"
          class="text-action-primary underline outline-none"
          @click="openUrl(ISSUES_URL)"
        >
          Report an issue
        </button>
      </p>
    </div>
  </div>
</template>
