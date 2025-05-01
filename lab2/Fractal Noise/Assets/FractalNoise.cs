using System;
using UnityEngine;

public class TerrainDeformer : MonoBehaviour
{
    public float frequency = 0.02f;
    public float amplitude = 8f;
    public int octaves = 8;
    public float lacunarity = 2.0f;
    public float persistence = 0.5f;
    private Terrain terrain;

    void Start()
    {
        terrain = GetComponent<Terrain>();
        GenerateTerrain();
    }

    void GenerateTerrain()
    {
        TerrainData terrainData = terrain.terrainData;
        int width = terrainData.heightmapResolution;
        int height = terrainData.heightmapResolution;

        float[,] heights = new float[width, height];

        for (int x = 0; x < width; x++)
        {
            for (int y = 0; y < height; y++)
            {
                float elevation = amplitude;
                float t_frequency = frequency;
                float t_amplitude = amplitude;
            
                for (int o = 0; o < octaves; o++) {
                    float x_sample = x * t_frequency;
                    float y_sample = y * t_frequency;

                    elevation += Mathf.PerlinNoise(x_sample, y_sample) * t_amplitude;
                    t_frequency *= lacunarity;
                    t_amplitude *= persistence;
                }

                float normalizedHeight = Mathf.Clamp01(elevation / terrainData.size.y);
                heights[x, y] = normalizedHeight;
            }
        }

        terrainData.SetHeights(0, 0, heights);
    }
}