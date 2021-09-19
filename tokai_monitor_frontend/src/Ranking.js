import React, { useState, useEffect } from 'react';
import { 
  Link, 
  useParams
} from 'react-router-dom';
import _ from 'lodash';

import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import Typography from '@mui/material/Typography';

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

  return (
    <>
      <Typography component="h2" variant="h6" color="primary" gutterBottom>
        {"ランキング"} 
      </Typography>
      <Table>
        <TableHead>
          <TableRow>
            <TableCell>{"タイトル"}</TableCell>
            <TableCell>{"再生回数"}</TableCell>
            <TableCell>{"高評価数"}</TableCell>
            <TableCell>{"低評価数"}</TableCell>
            <TableCell>{"コメント数"}</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {
            _.map(videos, video => {
              return (
                <TableRow key={video.id}>
                  <TableCell>{video.title}</TableCell>
                  <TableCell>{video.statistics.view_count}</TableCell>
                  <TableCell>{video.statistics.like_count}</TableCell>
                  <TableCell>{video.statistics.dislike_count}</TableCell>
                  <TableCell>{video.statistics.comment_count}</TableCell>
                </TableRow>
              );
            })
          }
        </TableBody>
      </Table>
    </>
  );
}

