import React from 'react';
import { Page, Text, View, Image, Document, StyleSheet } from '@react-pdf/renderer';
import { SIGNATURE } from '../constants/images';

import hyrome from '../assets/images/hyrome.png';
import citeole from '../assets/images/citeole.png';
import signature from '../assets/images/signature.png';

// Create styles
const styles = StyleSheet.create({
  page: {
    flexDirection: 'column',
  },
  section: {
    flexDirection: 'row',
    width: '100%',
  },
  textSection: {
    width: '100%',
    paddingVertical: 10,
    paddingHorizontal: 50,
  },
  rightSection: {
    width: '100%',
    paddingVertical: 10,
    paddingHorizontal: '50%',
  },
  hyrome: {
    width: 304,
    height: 150,
  },
  citeole: {
    width: 222,
    height: 100,
    marginTop: 25,
    marginLeft: 50,
  },
  signature: {
    width: 104,
    height: 61,
  },
});

// Create Document Component
const Attestation = () => (
  <Document>
    <Page size="A4" style={styles.page}>
      <View style={styles.section}>
        <Image src={hyrome} style={styles.hyrome} />
        <Image src={citeole} style={styles.citeole} />
      </View>
      <View style={styles.textSection}>
        <Text>Cit'Eole Hyrôme</Text>
        <Text>Société par actions simplifiée au capital de 431 200 €</Text>
        <Text>1 Le Vau Chaumier, Chanzeaux</Text>
        <Text>49750 CHEMILLE EN ANJOU</Text>
        <Text>845.010.107 RCS ANGERS</Text>
      </View>
      <View style={styles.rightSection}>
        <Text>Sébastien Cesbron</Text>
        <Text>Adresse</Text>
        <Text>Code Postal Ville</Text>
      </View>
      <View style={styles.rightSection}>
        <Image src={signature} style={styles.signature} />
        <Text>Sébastien Cesbron</Text>
        <Text>Président</Text>
      </View>
    </Page>
  </Document>
);

export default Attestation;
