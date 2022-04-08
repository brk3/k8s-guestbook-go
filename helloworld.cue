package helloworld

import (
  "dagger.io/dagger"
  "dagger.io/dagger/core"
  "universe.dagger.io/docker"
)

dagger.#Plan & {
  client: env: DOCKER_REGISTRY_PASSWORD: dagger.#Secret

  actions: {
    build: {
      clone: core.#GitPull & {
        remote: "https://github.com/brk3/k8s-guestbook-go/"
        ref:    "refs/heads/main"
      }

      build: docker.#Dockerfile & {
        source: clone.output
        dockerfile: path: "./Dockerfile"
      }

      push: docker.#Push & {
        auth: username: "brk3"
        auth: secret: client.env.DOCKER_REGISTRY_PASSWORD
        image: build.output
        dest: "docker.io/brk3/foo:123"
      }
    }
  }
}
