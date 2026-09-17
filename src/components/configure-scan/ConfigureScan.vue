<script setup lang="ts">
import { ref } from "vue";
import { open } from "@tauri-apps/plugin-dialog";
import List from "../list/List.vue";
import ListItem from "../list/ListItem.vue";
import Button from "../button/Button.vue";
import Icon from "../icon/Icon.vue";
import Tooltip from "../tooltip/Tooltip.vue";

defineProps<{ disabled?: boolean }>();
const emit = defineEmits<{ (e: "start-scan", paths: string[]): void }>();

const paths = ref<string[]>([]);

function addPaths(selected: string | string[] | null) {
  if (!selected) return;
  const picked = Array.isArray(selected) ? selected : [selected];
  paths.value = [...new Set([...paths.value, ...picked])];
}

async function addFiles() {
  addPaths(await open({ multiple: true }));
}

async function addFolder() {
  addPaths(await open({ multiple: true, directory: true }));
}

function removePath(path: string) {
  paths.value = paths.value.filter((p) => p !== path);
}

function startScan() {
  emit("start-scan", paths.value);
}
</script>

<template>
  <section class="w-full text-left">
    <h2 class="mb-6 text-[28px] font-semibold text-text-primary">Configure Your Scan</h2>

    <List v-if="paths.length" title="Paths to be scanned">
      <template #title-action>
        <Tooltip text="Files and folders listed here will be scanned for personal information.">
          <Icon name="information" />
        </Tooltip>
      </template>
      <ListItem v-for="path in paths" :key="path">
        <template #icon><Icon name="folder" /></template>
        <span class="break-all">{{ path }}</span>
        <template #actions>
          <button
            type="button"
            :disabled="disabled"
            class="flex h-12 w-12 items-center justify-center text-text-secondary outline-none hover:bg-text-primary/8 hover:text-text-primary disabled:cursor-not-allowed disabled:opacity-40"
            aria-label="Remove path"
            @click="removePath(path)"
          >
            <Icon name="subtract-alt" />
          </button>
        </template>
      </ListItem>
    </List>

    <div class="mt-6 flex flex-wrap items-start gap-6">
      <div>
        <Button :disabled="disabled" @click="addFolder">
          Choose folder path to scan
          <template #icon><Icon name="folder-add" /></template>
        </Button>
        <button
          type="button"
          :disabled="disabled"
          class="mt-2 block cursor-pointer text-[14px] tracking-[0.16px] text-action-primary underline outline-none hover:text-action-primary-hover disabled:cursor-not-allowed disabled:opacity-40"
          @click="addFiles"
        >
          or choose a specific file
        </button>
      </div>
      <Button :disabled="disabled || paths.length === 0" @click="startScan"> Start scan </Button>
    </div>
  </section>
</template>
