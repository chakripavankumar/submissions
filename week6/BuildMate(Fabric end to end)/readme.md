# Resource Management in Microsoft Fabric

Microsoft Fabric uses shared capacity for workloads across the workspace, so a resource-intensive Spark job can compete with Power BI queries and other workloads, slowing down the overall experience. I would monitor capacity utilisation, throttling, Spark job duration, and report performance. I would also schedule heavy transformations outside peak reporting hours where possible and avoid unnecessary notebook reruns. This helps manage resource consumption and maintain report responsiveness.
