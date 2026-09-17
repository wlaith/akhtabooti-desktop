<script setup lang="ts">
import { ref } from "vue";
import Icon from "../icon/Icon.vue";
import Button from "../button/Button.vue";

const props = defineProps<{ path: string; message: string }>();
defineEmits<{ (e: "close"): void }>();

const copied = ref(false);

async function copy() {
  await navigator.clipboard.writeText(props.message);
  copied.value = true;
  setTimeout(() => (copied.value = false), 1500);
}
</script>

<template>
  <div class="fixed inset-0 z-30 flex items-center justify-center bg-black/40" @click.self="$emit('close')">
    <div
      class="w-full max-w-[480px] bg-surface p-6 shadow-xl"
      role="dialog"
      aria-modal="true"
      aria-labelledby="error-detail-title"
    >
      <div class="mb-4 flex items-start justify-between gap-4">
        <h2 id="error-detail-title" class="text-[16px] font-semibold text-text-primary">Scan error</h2>
        <button
          type="button"
          class="text-text-secondary outline-none hover:text-text-primary"
          aria-label="Close"
          @click="$emit('close')"
        >
          <Icon name="close" :size="16" />
        </button>
      </div>

      <p class="mb-1 text-[12px] font-semibold tracking-[0.32px] text-text-secondary uppercase">Path</p>
      <p class="mb-4 break-all text-[14px] leading-[20px] text-text-primary">{{ path }}</p>

      <p class="mb-1 text-[12px] font-semibold tracking-[0.32px] text-text-secondary uppercase">Reason</p>
      <p class="mb-6 max-h-[240px] overflow-y-auto rounded bg-neutral-bg p-3 font-mono text-[13px] leading-[18px] break-all text-text-primary">
        {{ message }}
      </p>

      <div class="flex justify-end">
        <Button variant="outline" size="medium" @click="copy">
          <template #icon><Icon :name="copied ? 'checkmark-outline' : 'copy'" :size="16" /></template>
          {{ copied ? "Copied" : "Copy error" }}
        </Button>
      </div>
    </div>
  </div>
</template>
