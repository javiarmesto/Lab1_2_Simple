# Recomendaciones para el Trabajo en el Aula

## ¿Debo subir mis cambios al repositorio original?

No es recomendable que todos los alumnos suban sus cambios directamente al repositorio original, para evitar conflictos y confusiones.

### Alternativas recomendadas:

- **Fork individual:** Haz un fork del repositorio y trabaja en tu copia personal. Así puedes experimentar libremente y, si lo deseas, hacer un Pull Request para compartir tu solución.
- **Rama personal:** Crea una rama con tu nombre (`mi-solucion-[TuNombre]`) y trabaja en ella. Así no afectas la rama principal ni el trabajo de otros.
- **Repositorio propio:** Descarga el código y crea tu propio repositorio privado o local. Puedes compartir tu solución mediante ZIP, capturas de pantalla o vídeo demo.

### Entregables sugeridos

- Archivo `SOLUCION_[TuNombre].md` explicando tus cambios.
- Capturas de pantalla de la extensión funcionando.
- Código comentado.
- (Opcional) Pull Request o presentación en clase.

## Ejemplo de preservación de trabajo

```bash
# Crea tu propia rama para experimentar
git checkout -b mi-solucion-[TuNombre]
git add .
git commit -m "Mi implementación personalizada"

# O mejor aún: haz un fork del repositorio en GitHub
```