<script setup lang="ts">
import SidebarItem from "./SidebarItem.vue";
import { useTheme } from "../../composables/useTheme";

defineProps<{ active: "scan" | "guide" }>();
defineEmits<{ (e: "select", view: "scan" | "guide" | "about"): void }>();

const { isDark, toggle } = useTheme();
</script>

<template>
  <nav
    class="flex h-full w-13 shrink-0 flex-col items-center border-r border-text-primary/12 bg-surface py-2"
    aria-label="Primary"
  >
    <img src="/logo.png" alt="Akhtabooti" class="mb-2 h-6 w-6 shrink-0 object-contain" />
    <div class="mb-2 h-px w-8 shrink-0 bg-text-primary/12" aria-hidden="true" />

    <SidebarItem
      icon="scan-analyze"
      label="Scan"
      :active="active === 'scan'"
      @click="$emit('select', 'scan')"
    />

    <div class="mt-auto flex flex-col items-center gap-1">
      <SidebarItem
        :icon="isDark ? 'sun' : 'moon'"
        :label="isDark ? 'Switch to light mode' : 'Switch to dark mode'"
        @click="toggle"
      />
      <SidebarItem
        icon="help"
        label="How to use"
        :active="active === 'guide'"
        @click="$emit('select', 'guide')"
      />
      <SidebarItem icon="information" label="About" @click="$emit('select', 'about')" />
    </div>
  </nav>
</template>
