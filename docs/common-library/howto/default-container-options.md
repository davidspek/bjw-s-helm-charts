---
hide:
  - toc
---

# Setting default container options

It is possible to configure default container options under the `components.*.defaultContainerOptions` key. These options will be applied to all containers within the controller.

The following fields can be configured on this level:

- `args`
- `command`
- `env`
- `envFrom`
- `image`
- `resources`
- `securityContext`

## Only applying to regular containers

By default the `defaultContainerOptions` will be applied to both `initContainers` and regular `containers`.
If you wish to only apply the default options to regular containers, set `components.*.applyDefaultContainerOptionsToInitContainers` to `false`.

## Default value strategies

### Overwrite

The default strategy for configuring default container options is `overwrite`. This means that if a container has an entry for a default container option it will be overwritten entirely by the container-specific configuration.

This behavior can be set explicitly by setting `components.*.defaultContainerOptionsStrategy` to `overwrite`.

An (abbreviated) example of the `overwrite` strategy:

```yaml
components:
  main:
    defaultContainerOptions:
      resources:
        requests:
          memory: 1Gi
          cpu: 150m

    containers:
      main:
        ...
        resources:
          requests:
            cpu: 100m
```

The expected `resources` field on the `main` container is expected to look like this:

```yaml
resources:
  requests:
    cpu: 100m
```

### Merge

An alternative strategy for configuring default container options is `merge`. This means that if a container has an entry for a default container option it will be merged with the container-specific configuration.

This behavior can be set explicitly by setting `defaultContainerOptionsStrategy` to `merge`.

An (abbreviated) example of the `merge` strategy:

```yaml
components:
  main:
    defaultContainerOptionsStrategy: merge
    defaultContainerOptions:
      resources:
        requests:
          memory: 1Gi
          cpu: 150m

    containers:
      main:
        ...
        resources:
          requests:
            cpu: 100m
```

The expected `resources` field on the `main` container is expected to look like this:

```yaml
resources:
  requests:
    memory: 1Gi
    cpu: 100m
```
