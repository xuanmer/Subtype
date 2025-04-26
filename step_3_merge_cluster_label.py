import pandas as pd

source = "XUANWU"

best_cluster_num = {
    "SMC": 2,
}

for type_dis in ["SCD","NC"]:
    data_path = f'baseline/{type_dis}_ba_pad_b.csv'
    data = pd.read_csv(data_path)
    data['clusterLabel'] = None
    if type_dis == "NC":
        data.loc[data["diagnosis"]==type_dis, "clusterLabel"] = "NC"
    else:
        labels_path = f'ResultsCluster/{source}_{type_dis}_{best_cluster_num[type_dis]}_IDX.csv'
        labels = pd.read_csv(labels_path, header=None)
        final_labels = list(labels.mode().to_numpy().reshape(-1))    
        final_labels = [f'{type_dis}-{label}' for label in final_labels]
        print(f'{final_labels=}')
        data.loc[data["diagnosis"]==type_dis, "clusterLabel"] = final_labels

    data.to_csv(f'ResultsCluster/{source}_{type_dis}_subnetwork_Corrected_PAD_with_clusterLabel.csv') 