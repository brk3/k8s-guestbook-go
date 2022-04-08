package helloworld

import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"
  "universe.dagger.io/docker"
)

dagger.#Plan & {
	actions: {
		_alpine: core.#Pull & {source: "alpine:3"}

		// Hello world
		hello: core.#Exec & {
			input: _alpine.output
			args: ["echo", "hello, world!"]
			always: true
		}

    run: {
      //_alpine: core.#Pull & {source: "alpine:3"}

      _pull: docker.#Pull & { source: "index.docker.io/debian" }

      clone: core.#GitPull & {
        remote: "https://github.com/brk3/k8s-guestbook-go/"
        ref: "refs/heads/main"
      }

      read: core.#ReadFile & {
        input: clone.output
        path: "Dockerfile"
      }

      hello: core.#Exec & {
        input: _alpine.output
        args: ["echo", read.contents]
        always: true
      }
    }
	}
}
