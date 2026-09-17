<script setup lang="ts">
import { computed, onMounted, onUnmounted, ref } from "vue";
import type { PathStatus } from "../../composables/useScan";
import List from "../list/List.vue";
import ListItem from "../list/ListItem.vue";
import Icon from "../icon/Icon.vue";
import Spinner from "../spinner/Spinner.vue";
import Button from "../button/Button.vue";

const props = defineProps<{ pathStatus: Record<string, PathStatus> }>();
const emit = defineEmits<{ cancel: [] }>();

const paths = computed(() => Object.keys(props.pathStatus));

const elapsedSeconds = ref(0);
let timer: ReturnType<typeof setInterval> | undefined;

onMounted(() => {
  timer = setInterval(() => (elapsedSeconds.value += 1), 1000);
});
onUnmounted(() => clearInterval(timer));

const elapsedLabel = computed(() => {
  const minutes = Math.floor(elapsedSeconds.value / 60);
  const seconds = elapsedSeconds.value % 60;
  return `${minutes}:${seconds.toString().padStart(2, "0")}`;
});
</script>

<template>
  <section class="w-full text-left">
    <div class="mb-6 flex items-center justify-between">
      <h2 class="text-[28px] font-semibold text-text-primary">Scanning your files…</h2>
      <div class="flex items-center gap-4">
        <p class="text-[14px] text-text-secondary">Elapsed: {{ elapsedLabel }}</p>
        <Button variant="secondary" size="medium" @click="emit('cancel')">Cancel scan</Button>
      </div>
    </div>

    <List title="Paths currently being scanned">
      <ListItem v-for="path in paths" :key="path">
        <template #icon><Icon name="folder" /></template>
        <span class="break-all">{{ path }}</span>
        <template #actions>
          <Spinner v-if="pathStatus[path] === 'pending'" />
          <Icon v-else-if="pathStatus[path] === 'error'" name="subtract-alt" class="text-error" />
          <Icon v-else name="checkmark-outline" class="text-success" />
        </template>
      </ListItem>
    </List>
  </section>
</template>
