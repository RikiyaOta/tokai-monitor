import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import _ from 'lodash';

import Typography from '@mui/material/Typography';
import { DataGrid } from '@mui/x-data-grid';

import './App.css';

import { fetchRanking } from './helpers/api.js';

export default function Ranking() {
  const [videos, setVideos] = useState([]);
  const { channel_id } = useParams();

  useEffect(() => {
    async function fetchData(channel_id) {
      const page_number = 1;
      const page_size = 10;
      const sort_key = "view_count";
      const sort_type = "desc"
      const result = await fetchRanking(channel_id, page_number, page_size, sort_key, sort_type);
      setVideos(result.data.videos);
    };
    fetchData(channel_id);
  }, [channel_id]);

  const rows = _.map(videos, video => {
    return {
      id: video.id,
      title: video.title,
      view_count: video.statistics.view_count,
      like_count: video.statistics.like_count,
      dislike_count: video.statistics.dislike_count,
      comment_count: video.statistics.comment_count
    };
  });

  const columns = [
    {field: 'title', headerName: 'タイトル', width: 700},
    {field: 'view_count', headerName: '再生回数', width: 150},
    {field: 'like_count', headerName: '高評価数', width: 150},
    {field: 'dislike_count', headerName: '低評価数', width: 150},
    {field: 'comment_count', headerName: 'コメント数', width: 150}
  ];

  console.log('Rows:', rows);

  return (
    <main>
      <Typography component="h2" variant="h6" color="primary" gutterBottom>
        {"ランキング"} 
      </Typography>
      <div style={{ height: '100%', width: '100%'}}>
        <DataGrid autoHeight rows={rows} columns={columns} />
      </div>
    </main>
  );
}

