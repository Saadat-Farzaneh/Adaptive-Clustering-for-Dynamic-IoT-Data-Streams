# Adaptive Clustering for Dynamic IoT Data Streams
Most data stream clustering methods need to know how many clusters can be found in a data stream during its progress, or at least they are dependent on parameterization for their results. However, in the real world, there exist dynamic environments where the distribution of data stream can change over time. This fact creates the need for adaptive clustering algorithms that can adapt their parameters and methods to cluster the data based on changes in the data stream.

With the abundance of generated data, the main question is not just what to do with this data, but also what probabilities have not yet been considered. If new insights are gained from this data, they can in turn inspire new applications and services. This can go even further, disregarding previous knowledge and assumptions to retrieve new insights. However, the prior knowledge can influence expectations and therefore can cause an increase and/or change in the results.

One of the key issues in dealing with unknown data is how to find clusters and the necessary parameters to generate them using the information hidden within the data. In the current work, it is proposed that the distribution of the data can provide good indications for categorization. Since the data has multiple features, several options can be considered for approximating the parameters and ultimately clustering the data.

One of the important types of data that is of interest in many issues and fields such as geostatistics, water resource management, environmental conservation, traffic management, etc., is spatial data that is stored in spatial databases. These databases usually store other information in their records in addition to spatial locations. In the present work, the aim is to cluster data from one of these spatial databases that includes traffic information in the city of Aarhus in Denmark, using density-based clustering methods inspired by the additional stored information.

### Proposed Adaptive Density-Based Clustering 

With the increase in data production, the need for categorizing them to acquire knowledge from them has become more necessary. Nowadays, a lot of data is produced in various fields, which includes spatial (location) information, either entirely or partially, and some of these data and their collection areas were mentioned in the previous section. With the increase in the production of spatial (location) data, especially dynamic spatial (location) data, clustering them has become very important. One of the most common types of clustering methods for data available in spatial databases is density-based clustering methods. These methods usually have parameters that correctly determining them is of great importance in achieving suitable results from the clustering process. In this work, an adaptive density-based clustering method, whose main framework is based on the DBSCAN density-based clustering method, is introduced, and the parameter determination of this method is inspired by the distribution of values of different features present in these data and databases.

One of the ways to investigate the distribution of a quantity is to examine its probability density functions. In the present study, probability density functions of various features of stored data have been used to determine the parameters of the clustering method. In this research, probability density functions are used to obtain an average of different feature values, which is equal to the mathematical expectation calculated by these functions. The argument is that mathematical expectation can provide a suitable view of the features, as this average is not significantly influenced by outlier values in the set of values of a quantity, and it is not the case that they are completely ignored. This weighted average gives less weight to these values and pays more attention to the areas where the highest accumulation of values is located.

Since the proposed clustering method aims to investigate different feature values in order to obtain the parameters of the clustering method, a relationship must be established between these feature values and the desired parameters. For example, if the clustering method is based on DBSCAN, it requires determining the parameters of minimum number of points in a neighborhood (MinPts) and the radius of the neighborhood (Eps). For instance, in the present work, Eps is in units of distance and the features that are used to estimate Eps from the distribution of their values should be convertible to this unit. As an example, in the present study, probability density functions of the vehicle density values in units of distance are obtained and by dividing the estimated MinPts values by the expected value obtained from the mentioned probability density function, the desired value of Eps is calculated (as one of the desired Eps options).

The data stored in various databases can have many different features, which makes it possible for each of these features to be used to determine clustering parameters. As a result, different possible options are estimated for these parameters, and it is necessary to determine which of these options provides better clustering performance. In this work, it has been proposed to use a relative clustering evaluation index on some randomly sampled data using different options for the desired parameters to gain insight into the performance of each of the features in determining parameters. Since the proposed clustering method is based on density-based clustering methods, it is necessary to use a relative validation criterion that can be used in these methods. This validation criterion should be able to work with clusters of different shapes (convex and non-convex) and also consider data that is identified as noise or outliers in the calculation process. The DBCV validation criterion, introduced by Moulavi et al., has been shown to have suitable performance in dealing with such data and clustering methods, and is used in the present study to compare different options.

As different datasets may not have the same optimal values for clustering parameters, even the best selected features may not estimate the most suitable parameter values accurately. For this reason, it is suggested to make adjustments in parameter selection. In this study, using two concepts introduced by Ankerst and colleagues in the OPTICS clustering method, and Moulavi and colleagues in the DBCV validation metric, recommendations have been proposed for modifying the values of the Eps parameter. Finally, the effectiveness of these modifications has been evaluated through experiments.

Ankerst et al introduced the concept of "core distance to object p" in their OPTICS clustering method. In this study, it is argued that since core distances are not defined for data points that are not core objects in the DBSCAN clustering method, using this concept to adjust the Eps parameter has the undesirable effect of excluding outlier data points and boundary points, which are not strong points for cluster expansion.

As mentioned, the concept has already been introduced by Moulavi et al. They have defined a concept called "Kernel Distance of Object o with respect to all other points outside the cluster" in their own validation criteria. As Moulavi and colleagues have stated in introducing this concept, the aforementioned kernel distance is not dependent on a point to act as a strong density estimate, and considers all points in a cluster in such a way that objects closer to each other have a greater share of density compared to farther objects. Based on this property, it has been suggested in the current work that the use of this concept is likely to improve the Eps parameter.

Based on the above, in the proposed method, initially, stored data are selected as samples for certain moments, and then for each of the selected moments, different feature values that can be used in estimating the parameters are determined, and by applying kernel density estimation, probability functions are calculated for all the mentioned features and their expected values are computed. Depending on the nature of each of these features, they are made homogeneous with the parameters by applying some changes, and multiple options are provided for MinPts and Eps parameters using them. By running the DBSCAN clustering method using each of these options and obtaining the clusters, the DBCV metric is calculated based on the clustering results. In addition to obtaining the DBCV score, using the clustering results with each of the proposed parameter pairs, the distances between the kernels and the distances between the kernels and other points are also calculated. Then, the kernel density estimation is applied to these values, and using the expected value, the weighted mean value is obtained for the distances between the kernels and the distances between the kernels and other points, and each of them is given as options for Eps with the previous MinPts to DBSCAN, and clustering is re-run, and the DBCV score is obtained again based on the new results. At the end of this process, there will be three times the number of used features for estimating the Eps parameter for each moment, and with the application of this method for all selected moments, it can be examined which proposed option for the parameters has a better performance based on the DBCV scores. The pseudocode for this proposed method is presented below:

Input: Dynamic data set consisting of spatial information of data points.

Output: Set of density-based clusters.

Method:

(1) Select data stored at different time intervals.

(2) Perform the following steps for each selected time interval.

(3) Separate features that can be used to estimate parameters.

(4)   Apply KDE to these features and estimate probability density functions for each.

(5)   Calculate the expected values of each feature using the probability density functions.

(6)   Obtain parameter values directly or by making changes to them using the expected values of different features.

(7)       For each option of parameter values obtained:

(8)         Apply DBSCAN to the data and obtain clusters.

(9)         Calculate the DBCV metric for the clustering solution.

(10)      Calculate the "kernel distances" and "kernel distances with respect to other points in the cluster" values.

(11)  Apply KDE to the "kernel distances" and "kernel distances with respect to other points in the cluster" values.

(12)  Calculate the expected values for each and consider them as new options for Eps.

(13)  For each obtained Eps value in this section and based on the MinPts used for initial clustering, perform clustering again using DBSCAN.

(14)  Obtain the DBCV values for each of the new clustering solutions.

(15)  End for.

(16) End for.

(17) Determine the best method to determine parameters based on the obtained clustering solutions and examining the DBCV values.

(18) Calculate parameter values for other time intervals based on the determined method and perform clustering.

### Implementation of Algorithm in MATLAB

This section is dedicated to the implementation of algorithms in MATLAB

 *__Preparing data for use in the main file__*
 
 






