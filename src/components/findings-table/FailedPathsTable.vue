<script setup lang="ts">
import { ref } from "vue";
import { useI18n } from "vue-i18n";
import Icon from "../icon/Icon.vue";
import Button from "../button/Button.vue";
import ErrorDetailDialog from "../error-state/ErrorDetailDialog.vue";

defineProps<{ entries: [string, string][] }>();

const { t } = useI18n();
const GRID_COLS = "grid-cols-[40px_minmax(0,1fr)_minmax(0,1fr)_96px] gap-3";
const openEntry = ref<[string, string] | null>(null);
</script>

<template>
  <div class="w-full overflow-x-auto">
    <div :class="['sticky top-0 z-10 grid min-w-fit items-center bg-neutral-bg', GRID_COLS]">
      <span />
      <span class="min-w-0 truncate py-4 pr-2 pl-1 text-[14px] leading-[18px] font-semibold tracking-[0.16px] text-text-secondary">
        {{ t("failedPathsTable.path") }}
      </span>
      <span class="truncate py-4 pr-2 pl-1 text-[14px] leading-[18px] font-semibold tracking-[0.16px] text-text-secondary">
        {{ t("failedPathsTable.reason") }}
      </span>
      <span />
    </div>

    <div
      v-for="[path, reason] in entries"
      :key="path"
      :class="['grid min-w-fit items-center border-b border-text-primary/12 bg-surface', GRID_COLS]"
    >
      <span class="flex items-center justify-center py-3">
        <Icon name="subtract-alt" :size="16" class="text-error" />
      </span>
      <span
        dir="ltr"
        class="min-w-0 truncate py-3 pr-2 pl-1 text-[14px] leading-[18px] tracking-[0.16px] text-text-primary"
        :title="path"
      >
        {{ path }}
      </span>
      <span
        dir="ltr"
        class="min-w-0 truncate py-3 pr-2 pl-1 text-[14px] leading-[18px] tracking-[0.16px] text-text-secondary"
        :title="reason"
      >
        {{ reason }}
      </span>
      <span class="py-3 pr-2 pl-1">
        <Button variant="outline" size="small" @click="openEntry = [path, reason]">{{ t("failedPathsTable.viewError") }}</Button>
      </span>
    </div>

    <ErrorDetailDialog
      v-if="openEntry"
      :path="openEntry[0]"
      :message="openEntry[1]"
      @close="openEntry = null"
    />
  </div>
</template>
