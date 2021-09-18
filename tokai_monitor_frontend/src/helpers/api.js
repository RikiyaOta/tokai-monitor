import axios from 'axios'

// TODO; 環境変数で切り替えたい
const baseUrl='http://localhost:4000/api/v1';

export const fetchChannels = () => {
  const url = `${baseUrl}/channels`;
  return axios.get(url)
    .catch((error) => console.log(error))
};
