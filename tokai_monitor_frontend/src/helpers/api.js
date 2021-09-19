import axios from 'axios';

// TODO; 環境変数で切り替えたい
const baseUrl='http://localhost:4000/api/v1';

export const fetchChannels = () => {
  const url = `${baseUrl}/channels`;
  return axios.get(url)
    .catch((error) => console.log(error));
};

export const fetchRanking = (channel_id, page_number, page_size, sort_key, sort_type) => {
  const url = `${baseUrl}/videos/ranking`;
  const query = `channel.id=${channel_id}&page.page_number=${page_number}&page.page_size=${page_size}&page.sort_key=${sort_key}&page.sort_type=${sort_type}`;

  return axios.get(`${url}?${query}`)
    .catch((error) => console.log(error));
};
