# Multiple Services

## With a single component

It is possible to have multiple Service objects that point to a single component.

### Example

```yaml
components:
  main:
    containers:
      main:
        image:
          repository: ghcr.io/mendhak/http-https-echo
          tag: 31
          pullPolicy: IfNotPresent

service:
  main:
    component: main # (1)!
    ports:
      http:
        port: 8080
  second:
    component: main # (1)!
    ports:
      http:
        port: 8081
```

1. Point to the component with the "main" identifier

## With multiple components

It is also possible have multiple Service objects that point to different components.

### Example

```yaml
components:
  main:
    containers:
      main:
        image:
          repository: ghcr.io/mendhak/http-https-echo
          tag: 31
          pullPolicy: IfNotPresent
  second:
    containers:
      main:
        image:
          repository: ghcr.io/mendhak/http-https-echo
          tag: 31
          pullPolicy: IfNotPresent

service:
  main:
    component: main # (1)!
    ports:
      http:
        port: 8080
  second:
    component: main # (1)!
    ports:
      http:
        port: 8081
  third:
    component: second # (2)!
    ports:
      http:
        port: 8081
```

1. Point to the component with the "main" identifier
2. Point to the component with the "second" identifier
