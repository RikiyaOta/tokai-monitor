import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import _ from 'lodash';

import './App.css';

import AppBar from '@mui/material/AppBar';
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';
import CardMedia from '@mui/material/CardMedia';
import Container from '@mui/material/Container';
import CssBaseline from '@mui/material/CssBaseline';
import Grid from '@mui/material/Grid';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import { CardActionArea } from '@mui/material';
import { createTheme, ThemeProvider } from '@mui/material/styles';

import { fetchChannels } from './helpers/api.js';

const theme = createTheme();


export default function Home() {
  const [channels, setChannels] = useState([]);

  useEffect(() => {
    async function fetchData() {
      const result = await fetchChannels();
      const fetchedChannels = result.data.channels;
      setChannels(_.sortBy(fetchedChannels, ['index_number']));
    }
    fetchData();
  }, []);

  return (
    <main>
      <Container sx={{ py: 8 }} maxWidth="md">
        <Grid container spacing={4}>
          {
            _.map(channels, channel => {
              return (
                <Grid key={channel.id} item xs={12} sm={6} md={4}>
                  <Link to={`/channels/${channel.id}/ranking`} style={{"textDecoration": "none"}}>
                    <Card sx={{width: '100%', height: '100%', display: 'flex', flexDirection: 'column'}}>
                      <CardActionArea>
                        <CardMedia
                          component="img"
                          image={channel.thumbnail_url}
                        />
                        <CardContent>
                          <Typography gutterBottom variant="h5" component="div">
                            {channel.title}
                          </Typography>
                        </CardContent>
                      </CardActionArea>
                    </Card>
                  </Link>
                </Grid>
              );
            })
          }
        </Grid>
      </Container>
    </main>
  );
}
