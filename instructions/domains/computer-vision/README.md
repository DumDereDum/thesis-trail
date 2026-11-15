# Computer vision

## When to apply

Use for image and video analysis, detection, tracking, and spatial data such as lidar point clouds. Displaying images alone does not activate this area, and the method need not use machine learning.

## Baseline guidance

- Define the task, input modality, expected output, and the capture conditions the work covers.
- Explain annotation or reference-data conventions, including relevant coordinate systems, label definitions, and preprocessing.
- Choose quality measures suited to the task and inspect representative failure cases, including difficult capture conditions.
- When evaluating video or repeated observations, account for related frames, scenes, and objects when separating development and evaluation data.

## When relevant

- For real-time tracking or processing, measure end-to-end speed and quality on the stated hardware, resolution, and workload.
- For point clouds or geometry-dependent tasks, verify units, coordinate transforms, and how incomplete or sparse observations affect results.

## Related areas

- [Machine learning](../machine-learning/README.md): developing or evaluating learned models.
- [Infrastructure](../infrastructure/README.md): deployment and operation of processing services.
