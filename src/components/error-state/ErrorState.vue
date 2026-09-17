<script setup lang="ts">
import Icon from "../icon/Icon.vue";
import Button from "../button/Button.vue";

defineProps<{ detail?: string }>();
const emit = defineEmits<{ (e: "retry"): void }>();
</script>

<template>
  <section role="alert" class="flex w-full flex-col items-center gap-4 py-24 text-center">
    <Icon name="subtract-alt" :size="48" class="text-error" />
    <div class="max-w-md">
      <h2 class="text-[20px] font-semibold text-text-primary">Scan couldn't complete</h2>
      <p class="mt-2 text-[14px] text-text-secondary">
        None of the selected files or folders could be read.
      </p>
      <p v-if="detail" class="mt-2 text-[12px] break-all text-text-tertiary">{{ detail }}</p>
    </div>
    <Button size="medium" @click="emit('retry')">Try again</Button>
  </section>
</template>
