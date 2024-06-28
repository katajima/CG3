#pragma once
#pragma comment(lib,"d3d12.lib")
#pragma comment(lib,"dxgi.lib")
#pragma comment(lib,"dxguid.lib")
#pragma comment(lib,"dxcompiler.lib")
#include<cstdint>
#include<string>
#include<format>
#include<d3d12.h>
#include<dxgi1_6.h>
#include<cassert>
#include<dxgidebug.h>
#include<dxcapi.h>
#include<fstream>
#include<sstream>
#include<wrl.h>

#include"externals/DirectXTex/DirectXTex.h"
#include"externals/DirectXTex/d3dx12.h"

#include<vector>
#include"MathFanctions.h"


//出力ウィンドウを出す
void Log(const std::string& message);
//std::wstringからstd::stringへ変換する関数
//string->wstring
std::wstring ConvertString(const std::string& str);
//wstring->string
std::string ConvertString(const std::wstring& str);

////------CompileShader------////
IDxcBlob* CompileShader(
	//CompileShaderするShaderファイルへのパス
	const std::wstring& filePach,
	//CompileShaderに使用するProfile
	const wchar_t* profile,
	//初期化で生成したものを3つ
	IDxcUtils* dxcUtils,
	IDxcCompiler3* dxcCompiler,
	IDxcIncludeHandler* includeHandler);

// Material用のResource作成関数
Microsoft::WRL::ComPtr < ID3D12Resource> CreateBufferResource(Microsoft::WRL::ComPtr < ID3D12Device> device, size_t sizeInBytes);

// DescriptorHeapの作成関数
Microsoft::WRL::ComPtr < ID3D12DescriptorHeap>CreateDescriptorHeap(
	Microsoft::WRL::ComPtr < ID3D12Device> device, D3D12_DESCRIPTOR_HEAP_TYPE heapType, UINT numDescriptors, bool shaderVisible);

//03_00

//DirectTexを使ってTextureを読むためのLoadTextur関数
DirectX::ScratchImage LoadTexture(const std::string& filePath);


//DirectX12のTextureResourceを作る

Microsoft::WRL::ComPtr <ID3D12Resource> CreateTextureResource(Microsoft::WRL::ComPtr<ID3D12Device> device, const DirectX::TexMetadata& metadata);


//データを転送するUploadTextureData関数を作る
[[nodiscard]]
Microsoft::WRL::ComPtr < ID3D12Resource> UploadTextureData(ID3D12Resource* texture, const DirectX::ScratchImage& mipImages, Microsoft::WRL::ComPtr < ID3D12Device> device,
	Microsoft::WRL::ComPtr < ID3D12GraphicsCommandList> commandList);


//reateDepthStencilTextureResource
Microsoft::WRL::ComPtr < ID3D12Resource> CreateDepthStencilTextureResource(Microsoft::WRL::ComPtr < ID3D12Device> device, int32_t width, int32_t height);


////------DescriptorHandleの取得------////

// CPUHandle
D3D12_CPU_DESCRIPTOR_HANDLE GetCPUDescriptorHandle(Microsoft::WRL::ComPtr < ID3D12DescriptorHeap> descriptorHeap, uint32_t descriptorSize, uint32_t index);

// GPUHandle
D3D12_GPU_DESCRIPTOR_HANDLE GetGPUDescriptorHandle(Microsoft::WRL::ComPtr < ID3D12DescriptorHeap> descriptorHeap, uint32_t descriptorSize, uint32_t index);

//マテリアルデータを読み込む
MaterialData LoadMaterialTemplateFile(const std::string& directoryPath, const std::string& filename);

//モデルデータ読み込み
ModelData LoadOdjFile(const std::string& directoryPath, const std::string& filename);

