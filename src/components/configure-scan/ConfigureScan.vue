<script setup lang="ts">
import { ref } from "vue";
import { useI18n } from "vue-i18n";
import { open } from "@tauri-apps/plugin-dialog";
import List from "../list/List.vue";
import ListItem from "../list/ListItem.vue";
import Button from "../button/Button.vue";
import Icon from "../icon/Icon.vue";
import Tooltip from "../tooltip/Tooltip.vue";

defineProps<{ disabled?: boolean }>();
const emit = defineEmits<{ (e: "start-scan", paths: string[]): void }>();

const { t } = useI18n();
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
  <section class="w-full">
    <h2 class="mb-6 text-[28px] font-semibold text-text-primary">{{ t("configureScan.title") }}</h2>

    <List v-if="paths.length" :title="t('configureScan.pathsTitle')">
      <template #title-action>
        <Tooltip :text="t('configureScan.pathsTooltip')">
          <Icon name="information" />
        </Tooltip>
      </template>
      <ListItem v-for="path in paths" :key="path">
        <template #icon><Icon name="folder" /></template>
        <span dir="ltr" class="break-all">{{ path }}</span>
        <template #actions>
          <button
            type="button"
            :disabled="disabled"
            class="flex h-12 w-12 items-center justify-center text-text-secondary outline-none hover:bg-text-primary/8 hover:text-text-primary disabled:cursor-not-allowed disabled:opacity-40"
            :aria-label="t('configureScan.removePath')"
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
          {{ t("configureScan.chooseFolder") }}
          <template #icon><Icon name="folder-add" /></template>
        </Button>
        <button
          type="button"
          :disabled="disabled"
          class="mt-2 block cursor-pointer text-[14px] tracking-[0.16px] text-action-primary underline outline-none hover:text-action-primary-hover disabled:cursor-not-allowed disabled:opacity-40"
          @click="addFiles"
        >
          {{ t("configureScan.chooseFile") }}
        </button>
      </div>
      <Button :disabled="disabled || paths.length === 0" @click="startScan">
        {{ t("configureScan.startScan") }}
      </Button>
    </div>
  </section>
</template>
