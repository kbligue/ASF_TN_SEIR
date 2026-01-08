using Revise
using ASF_TN_SEIR

data_folder = "data"
W_file_name = "W.csv"
states_at_t0_file_name = "states_at_t0.csv"

W = read_matrix(data_folder, W_file_name)
states_at_t0 = read_matrix(data_folder, states_at_t0_file_name)
