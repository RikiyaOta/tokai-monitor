import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import _ from 'lodash';

import Typography from '@mui/material/Typography';
import { DataGrid } from '@mui/x-data-grid';

import './App.css';

import { fetchRanking } from './helpers/api.js';

const initPageNumber = 1;
const initPageSize = 10;
const initSortKey = "view_count";
const initSortType = "desc";
const initSortInfo = {sortKey: initSortKey, sortType: initSortType};
const initRowCount = 0;
const rowsPerPageOptions = [10, 20, 50];

export default function Ranking() {
  const [videos, setVideos] = useState([]);
  const [pageNumber, setPageNumber] = useState(initPageNumber);
  const [pageSize, setPageSize] = useState(initPageSize);
  const [sortInfo, setSortInfo] = useState(initSortInfo);
  const [rowCount, setRowCount] = useState(initRowCount);
  const { channel_id: channelId } = useParams();

  const handleSortChange = (sortInfos) => {
    if (sortInfos.length !== 1) return;

    const {field, sort} = sortInfos[0];
    const isChanged = (sortInfo.sortKey !== field || sortInfo.sortType !== sort);

    if (!isChanged) return;

    const newSortInfo = {sortKey: field, sortType: sort};
    setSortInfo(newSortInfo);
  };

  useEffect(() => {
    async function fetchData(channelId, pageNumber, pageSize, sortKey, sortType) {
      const result = await fetchRanking(channelId, pageNumber, pageSize, sortKey, sortType);
      const fetchedVideos = result.data.videos;
      const totalEntriesCount = result.data.page.total_entries_count;
      setVideos(result.data.videos);
      setRowCount(totalEntriesCount);
    };

    const {sortKey, sortType} = sortInfo;
    fetchData(channelId, pageNumber, pageSize, sortKey, sortType);
  }, [channelId, pageNumber, pageSize, sortInfo.sortKey, sortInfo.sortType]);

  const rows = _.map(videos, video => {
    return {
      id: video.id,
      title: video.title,
      view_count: video.view_count,
      like_count: video.like_count,
      dislike_count: video.dislike_count,
      comment_count: video.comment_count,
      view_count_last_day: video.view_count_last_day
    };
  });

  const columns = [
    {field: 'title', headerName: 'タイトル', width: 560, sortable: false, disableColumnMenu: true},
    {field: 'view_count', headerName: '再生回数', type: 'number', width: 150},
    {field: 'like_count', headerName: '高評価数', type: 'number', width: 150},
    {field: 'dislike_count', headerName: '低評価数', type: 'number', width: 150},
    {field: 'comment_count', headerName: 'コメント数', type: 'number', width: 150},
    {field: 'view_count_last_day', headerName: '再生回数(24h)', type: 'number', width: 170}
  ];

  return (
    <main>
      <Typography component="h2" variant="h6" color="primary" gutterBottom>
        {"ランキング"} 
      </Typography>
      <div style={{ height: '100%', width: '100%'}}>
        <DataGrid autoHeight 
                  rows={rows}
                  rowCount={rowCount}
                  columns={columns}
                  rowsPerPageOptions={rowsPerPageOptions}
                  page={pageNumber-1}
                  pageSize={pageSize}
                  pagination={true}
                  paginationMode={"server"}
                  loading={rows.length === 0}
                  isRowSelectable={() => false} 
                  isCellEditable={() => false}
                  disableSelectionOnClick={true}
                  disableColumnFilter={true}
                  sortingOrder={['asc', 'desc']}
                  onPageChange={(page) => setPageNumber(page+1)}
                  onPageSizeChange={setPageSize}
                  onSortModelChange={handleSortChange}
        />
      </div>
    </main>
  );
}

