# Imágenes de marca

Pon aquí los archivos de logo con **estos nombres exactos** (respeta
mayúsculas/minúsculas y la extensión) — el código ya los busca por ese
nombre y los usa automáticamente en cuanto existan, sin tocar nada más:

| Archivo | Dónde se usa |
|---|---|
| `logo_fybeca_tarjeta.png` | Tarjeta virtual de Fybeca (`VirtualCard`) |
| `logo_sanaSana.webp` | Tarjeta virtual de Sana Sana (`VirtualCard`) |
| `icono_fybeca.png` | Tarjeta de Empleados / Tarjeta Empresarial (`VirtualCard`) |
| `logo_fybeca.png` | Reservado para uso futuro (p. ej. logo del login) |

## Cómo probarlo

1. Copia los archivos aquí con esos nombres exactos.
2. Haz un **hot restart** (no alcanza con hot reload — es un cambio de
   assets empaquetados), o vuelve a correr `flutter run`.
3. Si un archivo no está o el nombre no coincide, la tarjeta usa
   automáticamente el diseño de respaldo (wordmark + ícono) — no rompe nada,
   así que puedes ir agregando los logos de a uno.

No hace falta tocar `pubspec.yaml` ni ningún archivo de Dart para que un
logo nuevo aparezca: esta carpeta completa ya está declarada como asset.
