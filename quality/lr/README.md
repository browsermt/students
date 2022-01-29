# Quality Model Tool

- The python script ```qualityestimator_json_to_bin.py``` converts a logistic regressor quality estimator model from json to binary file and vice versa.

- To converts a json to binary:

```console
  python qualityestimator_json_to_bin.py --to_json qe_model.json --out qe_model.bin
```

- To converts a binary to json:

```console
  python qualityestimator_json_to_bin.py --from_json qe_model.bin --out qe_model.json
```

- The json must follow this structure:
```json
{
    "mean_": [ 0.0, 0.0, 0.0, 0.0, ], 
    "scale_": [ 0.0, 0.0, 0.0, 0.0, ],
    "coef_": [ 0.0, 0.0, 0.0, 0.0, ], 
    "intercept_": 0.0 
}
```

- The binary file will have the following structure defined on [LogisticRegressorQualityEstimator](https://github.com/browsermt/bergamot-translator/blob/main/src/translator/quality_estimator.h#L100-L108).
