#pragma once
#include"assert.h"
#include<cassert>
#include<vector>
#include"cmath"
//行列
struct Matrix4x4
{
	float m[4][4];
};
//行列
struct Matrix3x3
{
	float m[3][3];
};

struct Vector4 final {
	float x;
	float y;
	float z;
	float w;
};

struct Vector3 final {
	float x, y, z;
};

struct Vector2 final {
	float x, y;
};

//AABB
struct AABB {
	Vector3 min; //!< 最小点
	Vector3 max; //!< 最大点
};


Vector3 Add(const Vector3& v1, const Vector3& v2);

Vector3 Subtract(const Vector3& v1, const Vector3& v2);

float Dot(const Vector3& v1, const Vector3& v2);

float Length(const Vector3& v);
float Length(const float& v);

float Clanp(float t);

Vector3 Nomalize(const Vector3& v);

//単位行列
Matrix4x4 MakeIdentity4x4();
//行列の積
Matrix4x4 Multiply(const Matrix4x4& v1, const Matrix4x4& v2);

Vector3 Multiply(const Vector3& v1, const Vector3& v2);

Vector3 Multiply(const float& v2, const Vector3& v1);
//移動行列
Matrix4x4 MakeTranslateMatrix(const  Vector3& translate);
//拡大縮小行列
Matrix4x4 MakeScaleMatrix(const  Vector3& scale);
//回転行列X
Matrix4x4 MakeRotateXMatrix(float rotate);
//回転行列Y
Matrix4x4 MakeRotateYMatrix(float rotate);
//回転行列Z
Matrix4x4 MakeRotateZMatrix(float rotate);
//逆行列
Matrix4x4 Inverse(const Matrix4x4& m);
//転置行列
Matrix4x4 Transpose(const Matrix4x4& m);
//アフィン変換
Matrix4x4 MakeAffineMatrixMatrix(const  Vector3& scale, const  Vector3& rotate, const  Vector3& translate);
//正射影行列
Matrix4x4 MakeOrthographicMatrix(float left, float top, float right, float bottom, float nearClip, float farClip);
//透視射影行列
Matrix4x4 MakePerspectiveFovMatrix(float forY, float aspectRatio, float nearClip, float farClip);
//ビューポート変換行列
Matrix4x4 MakeViewportMatrix(float leht, float top, float width, float height, float minDepth, float maxDepth);
//座標変換
Vector3 Transforms(const Vector3& vector, const Matrix4x4& matrix);

bool IsCollision(const AABB& aabb, const Vector3& point);
