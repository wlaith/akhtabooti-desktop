<script setup lang="ts">
import { ref } from "vue";
import { invoke } from "@tauri-apps/api/core";
import { open } from "@tauri-apps/plugin-dialog";

interface FilePIIs {
  filename: string;
  email_accounts: string[];
  phone_numbers: string[];
  other_piis: string[];
}

const results = ref<FilePIIs[]>([]);
const scanning = ref(false);
const error = ref("");
const hasScanned = ref(false);

async function scan(directory: boolean) {
  const selected = await open({ directory, multiple: false });
  if (!selected || Array.isArray(selected)) return;

  error.value = "";
  scanning.value = true;
  hasScanned.value = true;
  results.value = [];

  try {
    results.value = await invoke<FilePIIs[]>("scan_path", { path: selected });
  } catch (e) {
    error.value = String(e);
  } finally {
    scanning.value = false;
  }
}

function hasFindings(file: FilePIIs) {
  return (
    file.email_accounts.length > 0 ||
    file.phone_numbers.length > 0 ||
    file.other_piis.length > 0
  );
}
</script>

<template>
  <main
    class="flex min-h-screen flex-col items-center bg-neutral-100 px-4 pt-[8vh] pb-8 text-center font-sans text-neutral-900 dark:bg-neutral-800 dark:text-neutral-100"
  >
    <h1 class="text-2xl font-bold">Akhtabooti</h1>
    <p class="mx-auto mt-2 mb-6 max-w-md text-neutral-500 dark:text-neutral-400">
      Scan a file or folder on this device for personal information (PII).
      Everything runs locally — nothing leaves your computer.
    </p>

    <div class="flex justify-center gap-3">
      <button
        :disabled="scanning"
        class="cursor-pointer rounded-lg border border-transparent bg-white px-5 py-2.5 font-medium text-neutral-900 shadow-sm transition-colors outline-none hover:border-blue-500 active:border-blue-500 active:bg-neutral-200 disabled:cursor-default disabled:opacity-60 dark:bg-neutral-900/60 dark:text-white dark:active:bg-black/40"
        @click="scan(false)"
      >
        Scan File…
      </button>
      <button
        :disabled="scanning"
        class="cursor-pointer rounded-lg border border-transparent bg-white px-5 py-2.5 font-medium text-neutral-900 shadow-sm transition-colors outline-none hover:border-blue-500 active:border-blue-500 active:bg-neutral-200 disabled:cursor-default disabled:opacity-60 dark:bg-neutral-900/60 dark:text-white dark:active:bg-black/40"
        @click="scan(true)"
      >
        Scan Folder…
      </button>
    </div>

    <p v-if="scanning" class="mt-6">Scanning…</p>
    <p v-else-if="error" class="mt-6 text-red-600 dark:text-red-400">{{ error }}</p>

    <ul v-else-if="hasScanned" class="mx-auto mt-8 max-w-xl space-y-3 text-left">
      <li v-if="results.length === 0" class="text-neutral-500 dark:text-neutral-400">
        No files found.
      </li>
      <li
        v-for="file in results"
        :key="file.filename"
        class="rounded-lg border border-neutral-200 bg-white p-4 dark:border-neutral-600 dark:bg-neutral-700"
      >
        <div class="mb-2 font-semibold break-all">{{ file.filename }}</div>
        <div v-if="hasFindings(file)" class="flex flex-wrap gap-2">
          <span
            v-if="file.email_accounts.length"
            class="rounded-full bg-red-100 px-3 py-0.5 text-sm text-red-800 dark:bg-red-900/40 dark:text-red-300"
          >
            {{ file.email_accounts.length }} email{{ file.email_accounts.length > 1 ? "s" : "" }}
          </span>
          <span
            v-if="file.phone_numbers.length"
            class="rounded-full bg-red-100 px-3 py-0.5 text-sm text-red-800 dark:bg-red-900/40 dark:text-red-300"
          >
            {{ file.phone_numbers.length }} phone number{{ file.phone_numbers.length > 1 ? "s" : "" }}
          </span>
          <span
            v-for="tag in file.other_piis"
            :key="tag"
            class="rounded-full bg-red-100 px-3 py-0.5 text-sm text-red-800 dark:bg-red-900/40 dark:text-red-300"
          >
            {{ tag }}
          </span>
        </div>
        <div v-else class="text-sm text-green-600 dark:text-green-400">No PII detected</div>
      </li>
    </ul>
  </main>
</template>
