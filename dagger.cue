package dagger-react

import (
	"dagger.io/dagger"

	"dagger.io/dagger/core"
	"universe.dagger.io/yarn"
)

dagger.#Plan & {
	actions: {
		source: core.#Source & {
			path: "."
			exclude: [
				"node_modules",
				"build",
				"*.cue",
				"*.md",
				".git",
			]
		}

		build: yarn.#Script & {
			name:   "build"
			source: actions.source.output
		}

		test: yarn.#Script & {
			name:   "test"
			source: actions.source.output
			container: env: CI: "true"
		}
	}
}
