# English-Estonian Quality Model

## Generating model file

- To generate this binary file, we took the following steps:
  - First, create three variables: an intercept (float); two arrays: the mean vector and the std vector (contained in Scale structure); and the coefficients of the model (included in Array struct). The values are passed by hand and therefore are previously know by the user. For an example of how this is done, please refer to [this](https://github.com/abarbosa94/bergamot-translator/blob/quality-estimator-update/src/tests/units/quality_estimator_tests.cpp#L25)
  - These variables are then used to instantiate a LogisticRegressorQualityEstimator (LRQE) model, which has access to the toAlignedMemory method, so use it to convert an LRQE to AlignedMemory. An example about this can be seen [here](https://github.com/abarbosa94/bergamot-translator/blob/quality-estimator-update/src/tests/units/quality_estimator_tests.cpp#L43)
  - Write the AlignedMemory object to a file.
