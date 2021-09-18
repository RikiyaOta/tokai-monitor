import logo from './logo.svg';
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

const theme = createTheme();


export default function App() {
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <AppBar position="relative">
        <Toolbar>
          <Typography variant="h6" color="inherit">
            東海モニター
          </Typography>
        </Toolbar>
      </AppBar>
      <main>
        <Container sx={{ py: 8 }} maxWidth="md">
          <Grid container spacing={4}>
            <Grid item xs={12} sm={6} md={4}>
              <Card sx={{width: '100%', height: '100%', display: 'flex', flexDirection: 'column'}}>
                <CardActionArea>
                  <CardMedia
                    component="img"
                    image="https://yt3.ggpht.com/ytc/AKedOLTDLauymQQXmfG3S_r3ZTzw8ds1VstwhcwvHU_8OA=s88-c-k-c0x00ffffff-no-rj"
                  />
                  <CardContent>
                    <Typography gutterBottom variant="h5" component="div">
                      東海オンエア
                    </Typography>
                  </CardContent>
                </CardActionArea>
              </Card>
            </Grid>
          </Grid>
        </Container>
      </main>
    </ThemeProvider>
  );
}
