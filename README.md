# NEOX VM LAB — ISO Builder

Repositorio de construcción de las imágenes ISO experimentales de NEOX VM LAB.

## NEOX 0.1 Experimental

La primera edición está orientada a arrancar en una máquina virtual o PC compatible y entrar a un entorno de consola NEOX.

Incluye:

- arranque live amd64
- BIOS/UEFI mediante ISO híbrida
- consola NEOX
- comandos básicos de laboratorio
- información de versión y hardware
- build reproducible con GitHub Actions
- checksum SHA-256 de la ISO

> Esta es una versión experimental de laboratorio.

## Estructura

```
Neox-VM-Lab-isos/
├── .github/workflows/build-iso.yml
├── build/build-iso.sh
├── config/package-lists/
├── config/includes.chroot/
└── README.md
```

## Flujo de publicación

1. Hacer push a `main` o ejecutar manualmente el workflow.
2. GitHub Actions genera `neox-v0.1.0-amd64.iso`.
3. El workflow publica la ISO como artifact.
4. Descargar la ISO desde la ejecución de Actions.
5. Subir manualmente la ISO y su SHA-256 a un GitHub Release.

GitHub Actions soporta artifacts específicamente para conservar y descargar archivos producidos por un workflow. citeturn0search0

## Próximas versiones

- NEOX 0.2 — herramientas de administración
- NEOX 0.3 — servicios base
- NEOX 0.4 — interfaz gráfica experimental
- NEOX 1.0 — primera edición estable
