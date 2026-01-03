# VLM-ISEQL Task Report

## 1. Task Specification
> In the context of the video surveillance architecture combining VLM >and ISEQL, please
implement and test the first two levels of the pipeline on video in different contexts
(including homemade). As regards VLMs, you could use qwen 2.5 or other versions on ollama,
gemini 1.5 robotics view on Google AI studio via API Key, or any other tool deemed
appropriate

## 2 Pipeline Description
As the task requires the implementation of the first two levels of the pipeline, we reported them in the following image, taken from the course slides.

>![Pipeline](./report_images/pipeline.png)

## 3. Implemented Pipeline
In this section we'll be going through the entire first two-level pipeline implementation, from the video taken in input by the VLM to the Simple Time-Point Label provided to the third level of the entire pipeline.

Obviously, since we are pretty limited from the VLM side, pretty much due to tokens, we'll test this pipeline on simple video and scenarios, like couriers dropping off packages.

### 3.1 From Video to VLM: Reaching the First Level of the Pipeline
Video recorded by video camera cannot be provided directly to the VLM, there must be a **preprocessing phase**.

First of all frames must be **extracted** from the video and then a grid must be **overlapped**. To provide the VLM with a valid input, we also **convert** frames in **base 64**.

> ![From Video to Pipeline](./report_images/from_video_to_vlm.png)

#### 3.1.1 Frame Extraction
Since we're considering simple video and scenarios and don't want to overload the VLM, for the "dropping off packages" topic, extracting 1.5 FPS (1 frame per 0.66 seconds) from a video is sufficient. It's the best trade-off that we could make between VLM image-reasoning completion time and information amount provided per frame.

#### 3.1.2 Grid Overlapping
Referring to the original pipeline, the overlapped grid frame (the so called **Visual Image**) is generated in this phase, before going to the VLM. This is possible through a simple Python script that applies the grid to the frame, without relying too much on the VLM, that is limited to image-reasoning purposes.

Each frame has been structured into a 1x3 matrix, so 1 row and 3 columns, in this case we will refer to them as **3 cells**. This structure will also be used by the VLM to provide descriptions of what happens in each cell of the frame.

![Frame Gridded](./report_images/gridded_frame.png)

#### 3.1.3 Base 64 Conversion
The final step of this first phase in the **base 64 conversion** of each frame, that is the input for the next layer, the VLM.


### 3.2 From VLM to Data Adaptation Module: From the First to the Second Level of the Pipeline
The first level of the pipeline **analyses frames** in base 64, elaborated in the previous preprocessing phase.
Now **Frame-Reasoning** is performed by the VLM to provide the next level a coherent input.

#### 3.2.1 VLM choice
We tried several models on ollama, and this was by far the most challenging part of the project, because powerful models comes with limited, very limited tokens. So we had to find a trade-off between power and enough tokens to test our project.

On four video we tested five models in total, with different amount of parameters:

```python
class Models(Enum):
    qwen3_2 = "qwen3-vl:2b"
    qwen3_4 = "qwen3-vl:4b"
    qwen3_8 = "qwen3-vl:8b"
    gemma3_4 = "gemma3:4b"
    gemma3_12 = "gemma3:12b"
    mistral_8 = "ministral-3:8b"
    mistral_14 = "ministral-3:14b"
```

Even if not listed here, we also tried Google AI Robotics 1.5, and even if it performs pretty well, it has a RPD and RPM insufficient even for testing.

About some of the models listed:
- qwen3_8 is very good in general, but it is very slow on our hardware since it takes ~20 minutes per video analysis
- gemma3_12 is not providing good outcomes... Several analysis are wrong
- mistral_14 is pretty quick since it takes ~15 minutes per frame, but don't recognize packages on the floor

We decided to use ```qwen3_8``` since it was the one that gave us the tradeoff that we were searching.

#### 3.2.2 VLM: Frame-Reasoning
The **base 64** string from the **preprocessing phase** is analysed by the VLM and produces a **textual description** already **serialized**, it is a JSON-string for each cell of the frame.

This is made possible by the prompt that was provided to the VLM:

> You are a video surveillance VLM, analyze the image I sent you and reply only with a json representation of what is in each grid cell.
>
> **notice that {SCENE_INFO_FEDEX} is the context of the provided video, this row is not included in the prompt**
>
> Scene info: {SCENE_INFO_FEDEX}
>
> Each cell in the json is numbered from left to right.
> If you think that shippers are carrying a box or a package insert it in the json inside objects section. Consider that Boxes or Packages can be placed on the floor by a person or shippers.
>
> Inside the json insert the action of what the person is doing, explain it in the description.
>
> Inside the json action: if the shipper or the person is delivering/carrying the box/package/object insert "carrying an object", if the shipper is releasing the box/package/object insert "releasing an object".
>
> If you don't recognize the objects inside the cells but are related to boxes or packages insert "Other" in the objects section, instead if it is a package insert "package".
>
> If you see boxes or packages not being interacted with anybody don't insert any action, insert the presence of the object in the objects section of the json.
>
> Print the output as a json for all 3 grid cells

And about these cells... Here you can see the structure of each cell in a JSON-string format:

> **Referring to the i-th cell of the frame**
>
>```json
>  "cell_i": {
>    "reasoning": "",
>    "people": "",
>    "objects": "",
>    "action": ""
>  }
>```

Since a video is composed by multiple frames, these cells will be packed into a JSON-array string.

This serialized data will be the input for the next level, the Data Adaptation Module.

### 3.3 From Data Adaptation Module: To the Third Level of the Pipeline
Given serialized data provided by the VLM (the first level of the pipeline), the Data Adaptation Module **deserializes** data and provides input for the next level of the pipeline, the **Interval Action Detector**.

#### 3.3.1 Deserialization and Third Level Input Formatting
This second level of the pipeline is specialized in deserializing the input, retrieving the original JSON structure. This is then **converted** into a suitable temporal database-like format for the next level, respecting the **Single Time-Point Labeling** introduced in the full pipeline.

The JSON structure is suitable as an input for the next phase, but we still decided to use a ```.csv``` format for this purpose.